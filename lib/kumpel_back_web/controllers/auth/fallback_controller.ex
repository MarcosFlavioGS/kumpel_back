defmodule KumpelBackWeb.Auth.FallbackController do
  @moduledoc """
    call functions for the fallback controller and
    puts especific error views considering parameters received from captured
    errors from the auth_controller
  """
  use KumpelBackWeb, :controller

  @spec call(Plug.Conn.t(), {:error, :not_found}) :: Plug.Conn.t()
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: KumpelBackWeb.Auth.ErrorJSON)
    |> render(:error, status: :not_found)
  end

  @spec call(Plug.Conn.t(), {:error, :unauthorized}) :: Plug.Conn.t()
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: KumpelBackWeb.Auth.ErrorJSON)
    |> render(:error, status: :unauthorized)
  end

  @spec call(Plug.Conn.t(), {:error, :missing_refresh}) :: Plug.Conn.t()
  def call(conn, {:error, :missing_refresh}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: KumpelBackWeb.Auth.ErrorJSON)
    |> render(:error, status: :bad_request, message: "Missing or empty refresh token")
  end

  @spec call(Plug.Conn.t(), {:error, :invalid_refresh}) :: Plug.Conn.t()
  def call(conn, {:error, :invalid_refresh}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: KumpelBackWeb.Auth.ErrorJSON)
    |> render(:error, status: :unauthorized, message: "Invalid or expired refresh token")
  end
end
