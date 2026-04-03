defmodule KumpelBackWeb.Plugs.AuthTest do
  use KumpelBackWeb.ConnCase

  alias KumpelBackWeb.Plugs.Auth
  alias KumpelBack.TestFixtures

  defp call_plug(conn) do
    conn
    |> Plug.Conn.fetch_query_params()
    |> then(&%{&1 | params: Map.put(&1.params, "_format", "json")})
    |> Auth.call(Auth.init([]))
  end

  describe "call/2" do
    test "halts with 401 when authorization header is missing" do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> call_plug()

      assert conn.halted
      assert conn.status == 401
    end

    test "halts with 401 when bearer token is invalid" do
      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer invalid")
        |> call_plug()

      assert conn.halted
      assert conn.status == 401
    end

    test "assigns user token data when token is valid" do
      user = TestFixtures.insert_user!()
      token = KumpelBackWeb.Token.sign(user)

      conn =
        build_conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{token}")
        |> call_plug()

      refute conn.halted
      assert conn.assigns.user_id.user_id == user.id
    end
  end
end
