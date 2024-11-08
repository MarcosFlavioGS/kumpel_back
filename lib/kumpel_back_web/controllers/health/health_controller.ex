defmodule KumpelBackWeb.Health.HealthController do
  use KumpelBackWeb, :controller

  def index conn, _params do
	conn
	|> put_status(:ok)
	|> render(:index, status: :ok)
  end
end
