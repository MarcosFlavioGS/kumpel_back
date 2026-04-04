defmodule KumpelBackWeb.Health.HealthController do
  use KumpelBackWeb, :controller

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> render(:index, status: :ok)
  end
end
