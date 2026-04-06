defmodule KumpelBackWeb.Auth.AuthControllerTest do
  use KumpelBackWeb.ConnCase

  alias KumpelBack.TestFixtures

  setup do
    on_exit(fn -> Cachex.clear(:rate_limit_cache) end)
    :ok
  end

  defp post_login(conn, params) do
    conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept", "application/json")
    |> post(~p"/api/auth/login", TestFixtures.json_body(params))
  end

  defp post_refresh(conn, params) do
    conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept", "application/json")
    |> post(~p"/api/auth/refresh", TestFixtures.json_body(params))
  end

  describe "login/2" do
    test "returns tokens for valid credentials" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, _} = KumpelBack.Users.create(attrs)

      conn = post_login(build_conn(), %{"mail" => attrs["mail"], "password" => attrs["password"]})
      body = json_response(conn, 200)

      assert body["status"] == "Authorized"
      assert is_binary(body["token"])
      assert is_binary(body["refresh"])
    end

    test "returns 401 for wrong password" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, _} = KumpelBack.Users.create(attrs)

      conn =
        post_login(build_conn(), %{"mail" => attrs["mail"], "password" => "WrongPass1!"})

      assert json_response(conn, 401)
    end

    test "returns 404 for unknown user" do
      conn =
        post_login(build_conn(), %{
          "mail" => "nobody@example.com",
          "password" => TestFixtures.valid_password()
        })

      assert json_response(conn, 404)
    end

    test "returns 429 after too many attempts for the same email" do
      mail = "ratelimit#{System.unique_integer([:positive])}@example.com"

      for _ <- 1..5 do
        conn = post_login(build_conn(), %{"mail" => mail, "password" => "WrongPass1!"})
        assert conn.status in [401, 404]
      end

      conn = post_login(build_conn(), %{"mail" => mail, "password" => "WrongPass1!"})
      assert conn.status == 429
    end
  end

  describe "refresh/2" do
    test "returns new access and refresh tokens for a valid refresh token" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, _} = KumpelBack.Users.create(attrs)

      conn = post_login(build_conn(), %{"mail" => attrs["mail"], "password" => attrs["password"]})
      login_body = json_response(conn, 200)
      refresh = login_body["refresh"]

      conn = post_refresh(build_conn(), %{"refresh" => refresh})
      body = json_response(conn, 200)

      assert body["status"] == "Authorized"
      assert is_binary(body["token"])
      assert is_binary(body["refresh"])
      assert body["token"] != login_body["token"]
      assert body["refresh"] != refresh
    end

    test "returns 400 when refresh is missing" do
      conn = post_refresh(build_conn(), %{})
      assert json_response(conn, 400)
    end

    test "returns 401 for invalid refresh token" do
      conn = post_refresh(build_conn(), %{"refresh" => "not-a-valid-token"})
      assert json_response(conn, 401)
    end

    test "returns 404 when user no longer exists" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, user} = KumpelBack.Users.create(attrs)

      conn = post_login(build_conn(), %{"mail" => attrs["mail"], "password" => attrs["password"]})
      refresh = json_response(conn, 200)["refresh"]

      assert {:ok, _} = KumpelBack.Users.delete(user.id)

      conn = post_refresh(build_conn(), %{"refresh" => refresh})
      assert json_response(conn, 404)
    end
  end

  describe "CORS preflight" do
    test "OPTIONS with preflight headers returns 204 and CORS headers" do
      conn =
        build_conn()
        |> put_req_header("origin", "http://localhost:3000")
        |> put_req_header("access-control-request-method", "POST")
        |> options(~p"/api/auth/login")

      assert conn.status == 204
      assert get_resp_header(conn, "access-control-allow-origin") == ["http://localhost:3000"]
    end
  end
end
