defmodule KumpelBackWeb.Messages.FallbackController do
  @moduledoc false

  use KumpelBackWeb, :controller

  @spec call(Plug.Conn.t(), {:error, :not_found}) :: Plug.Conn.t()
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: KumpelBackWeb.Messages.ErrorJSON)
    |> render(:error, status: :not_found)
  end

  @spec call(Plug.Conn.t(), {:error, :invalid_cursor}) :: Plug.Conn.t()
  def call(conn, {:error, :invalid_cursor}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: KumpelBackWeb.Messages.ErrorJSON)
    |> render(:error, status: :invalid_cursor)
  end
end
