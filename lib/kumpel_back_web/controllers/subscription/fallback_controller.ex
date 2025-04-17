defmodule KumpelBackWeb.Subscription.FallbackController do
  @moduledoc """
  Handles fallback errors from subscription
  """

  use KumpelBackWeb, :controller

  def call(conn, {:error, message}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: KumpelBackWeb.Subscription.ErrorJSON)
    |> render(:error, %{status: :not_found, message: message})
  end

  def call(conn, {:error, :already_subscribed}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: KumpelBackWeb.Subscription.ErrorJSON)
    |> render(:error, %{status: :bad_request, message: "User is already subscribed to the room"})
  end

end
