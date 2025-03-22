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
      assign(conn, :user_id, data)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(json: KumpelBackWeb.ErrorJSON)
        |> Phoenix.Controller.render(:error, status: :unauthorized)
        |> halt()
    end
  end
end
