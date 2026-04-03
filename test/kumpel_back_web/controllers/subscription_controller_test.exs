defmodule KumpelBackWeb.Subscription.SubscriptionControllerTest do
  use KumpelBackWeb.ConnCase

  alias KumpelBack.TestFixtures

  defp post_subscribe(conn, params) do
    conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept", "application/json")
    |> post(~p"/api/rooms/subscribe", TestFixtures.json_body(params))
  end

  describe "subscribe/2" do
    test "subscribes authenticated user to a room" do
      adm = TestFixtures.insert_user!()
      joiner = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      conn =
        build_conn()
        |> TestFixtures.put_auth(joiner)
        |> post_subscribe(%{"code" => room.code, "name" => room.name})

      body = json_response(conn, 200)
      assert body["message"] == "Successfully subscribed to room"
    end

    test "returns 404 when room is not found" do
      user = TestFixtures.insert_user!()

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> post_subscribe(%{"code" => "NOTFOUND1", "name" => "Nope"})

      assert json_response(conn, 404)
    end

    test "returns 404 when user is already subscribed (current API behavior)" do
      adm = TestFixtures.insert_user!()
      joiner = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)
      params = %{"code" => room.code, "name" => room.name}

      conn_ok =
        build_conn()
        |> TestFixtures.put_auth(joiner)
        |> post_subscribe(params)

      assert json_response(conn_ok, 200)

      conn_dup =
        build_conn()
        |> TestFixtures.put_auth(joiner)
        |> post_subscribe(params)

      assert json_response(conn_dup, 404)
    end

    test "returns 401 without authentication" do
      conn =
        post_subscribe(build_conn(), %{"code" => "X", "name" => "Y"})

      assert json_response(conn, 401)
    end
  end
end
