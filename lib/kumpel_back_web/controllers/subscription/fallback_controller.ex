defmodule KumpelBackWeb.Subscription.FallbackController do
  @moduledoc """
  Handles fallback errors from subscription
  """

  use KumpelBackWeb, :controller

  @spec call(Plug.Conn.t(), {:error, :already_subscribed}) :: Plug.Conn.t()
  def call(conn, {:error, :already_subscribed}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: KumpelBackWeb.Subscription.ErrorJSON)
    |> render(:error, %{status: :bad_request, message: "User is already subscribed to the room"})
  end

  @spec call(Plug.Conn.t(), {:error, String.t()}) :: Plug.Conn.t()
  def call(conn, {:error, message}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: KumpelBackWeb.Subscription.ErrorJSON)
    |> render(:error, %{status: :not_found, message: message})
  end
end
