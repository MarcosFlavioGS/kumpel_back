defmodule KumpelBackWeb.Rooms.RoomsControllerTest do
  use KumpelBackWeb.ConnCase

  alias KumpelBack.TestFixtures

  describe "show/2 and index/2 (public)" do
    test "show returns a room" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}")
      body = json_response(conn, 200)

      assert body["id"] == room.id
      assert body["name"] == room.name
    end

    test "show returns 404 for unknown room" do
      conn = get(build_conn(), ~p"/api/rooms/#{Ecto.UUID.generate()}")
      assert json_response(conn, 404)
    end

    test "index lists rooms when data exists" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      conn = get(build_conn(), ~p"/api/rooms")
      body = json_response(conn, 200)
      assert is_list(body)
      assert Enum.any?(body, &(&1["id"] == room.id))
    end

    test "index returns 404 when no rooms exist" do
      conn = get(build_conn(), ~p"/api/rooms")
      assert json_response(conn, 404)
    end
  end

  describe "authenticated room mutations" do
    test "create returns 201 with new room" do
      user = TestFixtures.insert_user!()

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "application/json")
        |> post(~p"/api/rooms", TestFixtures.json_body(%{"name" => "New Room"}))

      body = json_response(conn, 201)
      assert body["data"]["name"] == "New Room"
      assert is_binary(body["data"]["code"])
    end

    test "update changes room name" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "application/json")
        |> put(
          ~p"/api/rooms/#{room.id}",
          TestFixtures.json_body(%{"name" => "Renamed", "code" => room.code})
        )

      body = json_response(conn, 200)
      assert body["name"] == "Renamed"
    end

    test "delete removes the room" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> delete(~p"/api/rooms/#{room.id}")

      body = json_response(conn, 200)
      assert body["message"] =~ "deleted"
    end
  end
end
