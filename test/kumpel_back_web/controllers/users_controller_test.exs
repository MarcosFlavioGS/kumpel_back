defmodule KumpelBackWeb.Users.UsersControllerTest do
  use KumpelBackWeb.ConnCase

  alias KumpelBack.TestFixtures

  defp post_json(conn, path, body) do
    conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept", "application/json")
    |> post(path, body)
  end

  describe "create/2 (public)" do
    test "creates user and returns token" do
      attrs = TestFixtures.user_attrs()

      conn =
        post_json(build_conn(), ~p"/api/users", TestFixtures.json_body(attrs))

      body = json_response(conn, 201)
      assert body["message"] == "User created !"
      assert body["data"]["mail"] == attrs["mail"]
      assert is_binary(body["token"])
      assert is_binary(body["refresh"])
    end

    test "returns 400 for invalid params" do
      conn =
        post_json(
          build_conn(),
          ~p"/api/users",
          TestFixtures.json_body(%{"name" => "ab", "mail" => "bad", "password" => "x"})
        )

      assert json_response(conn, 400)
    end
  end

  describe "show/2 (public)" do
    test "returns user by id" do
      user = TestFixtures.insert_user!()
      conn = get(build_conn(), ~p"/api/users/#{user.id}")

      body = json_response(conn, 200)
      assert body["id"] == user.id
      assert body["mail"] == user.mail
    end

    test "returns 404 for unknown id" do
      conn = get(build_conn(), ~p"/api/users/#{Ecto.UUID.generate()}")
      assert json_response(conn, 404)
    end
  end

  describe "index/2 (public)" do
    test "lists users when data exists" do
      user = TestFixtures.insert_user!()
      conn = get(build_conn(), ~p"/api/users")

      body = json_response(conn, 200)
      assert Enum.any?(body["users"], &(&1["user_id"] == user.id))
    end

    test "returns 404 when no users exist" do
      conn = get(build_conn(), ~p"/api/users")
      assert json_response(conn, 404)
    end
  end

  describe "authenticated routes" do
    test "currentUser returns the authenticated user" do
      user = TestFixtures.insert_user!()

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> get(~p"/api/currentUser")

      body = json_response(conn, 200)
      assert body["id"] == user.id
    end

    test "update modifies the user" do
      user = TestFixtures.insert_user!()

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> put_req_header("content-type", "application/json")
        |> put_req_header("accept", "application/json")
        |> put(
          ~p"/api/users/#{user.id}",
          TestFixtures.json_body(%{
            "name" => "Updated Name",
            "mail" => user.mail
          })
        )

      body = json_response(conn, 200)
      assert body["name"] == "Updated Name"
    end

    test "delete removes the user" do
      user = TestFixtures.insert_user!()

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> delete(~p"/api/users/#{user.id}")

      body = json_response(conn, 200)
      assert body["message"] == "User deleted !"
      assert body["user_id"] == user.id
    end

    test "returns 401 without bearer token" do
      conn = get(build_conn(), ~p"/api/currentUser")
      assert json_response(conn, 401)
    end

    test "returns 404 when deleting unknown user" do
      user = TestFixtures.insert_user!()

      conn =
        build_conn()
        |> TestFixtures.put_auth(user)
        |> delete(~p"/api/users/#{Ecto.UUID.generate()}")

      assert json_response(conn, 404)
    end
  end
end
