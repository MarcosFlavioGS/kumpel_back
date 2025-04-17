defmodule KumpelBackWeb.Subscription.SubscriptionController do
  @moduledoc """
  Module to handle subscription requests
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Subscription

  action_fallback KumpelBackWeb.Subscription.FallbackController

  def subscribe(conn, %{"room_id" => room_id}) do
    with {:ok, message} <- Subscription.subscribe(conn.assigns.user_id, room_id) do
      conn
      |> put_status(:ok)
      |> render(:subscribe, message: message)
    end
  end

  @doc """
  handle Next.js options request
  """
  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-methods", "POST, OPTIONS")
    |> send_resp(200, "")
  end
end
