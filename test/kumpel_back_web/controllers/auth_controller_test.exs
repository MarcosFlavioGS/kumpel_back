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

  describe "options/2" do
    test "responds to OPTIONS" do
      conn = options(build_conn(), ~p"/api/auth/login")
      assert conn.status == 200
    end
  end
end
