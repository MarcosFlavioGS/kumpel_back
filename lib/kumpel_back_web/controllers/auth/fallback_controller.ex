defmodule KumpelBackWeb.Auth.FallbackController do
  @moduledoc """
    call functions for the fallback controller and
    puts especific error views considering parameters received from captured
    errors from the auth_controller
  """
  use KumpelBackWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: KumpelBackWeb.Users.ErrorJSON)
    |> render(:error, status: :not_found)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: KumpelBackWeb.Users.ErrorJSON)
    |> render(:error, status: :unauthorized)
  end
end
