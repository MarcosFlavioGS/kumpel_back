defmodule KumpelBackWeb.Users.FallbackController do
  @moduledoc """
    call functions for the fallback controller and
    puts especific error views considering parameters received from captured
    errors from the users_controller
  """
  use KumpelBackWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: KumpelBackWeb.Users.ErrorJSON)
    |> render(:error, status: :not_found)
  end

  def call(conn, {:error, changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: KumpelBackWeb.Users.ErrorJSON)
    |> render(:error, changeset: changeset)
  end
end
