defmodule KumpelBackWeb.Plugs.Auth do
  @moduledoc """
  Module for authentication plugs
  """
  import Plug.Conn

  alias KumpelBackWeb.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- Token.verify(token) do
      conn
      |> assign(:user_id, data)
      |> put_security_headers()
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> put_security_headers()
        |> Phoenix.Controller.put_view(json: KumpelBackWeb.ErrorJSON)
        |> Phoenix.Controller.render(:error, status: :unauthorized)
        |> halt()
    end
  end

  defp put_security_headers(conn) do
    conn
    |> put_resp_header("x-content-type-options", "nosniff")
    |> put_resp_header("x-frame-options", "DENY")
    |> put_resp_header("x-xss-protection", "1; mode=block")
    |> put_resp_header("strict-transport-security", "max-age=31536000; includeSubDomains")
    |> put_resp_header("content-security-policy", "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';")
    |> put_resp_header("referrer-policy", "strict-origin-when-cross-origin")
    |> put_resp_header("permissions-policy", "geolocation=(), microphone=(), camera=()")
  end
end
