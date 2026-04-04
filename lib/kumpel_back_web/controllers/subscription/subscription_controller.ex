defmodule KumpelBackWeb.Subscription.SubscriptionController do
  @moduledoc """
  Module to handle subscription requests
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Subscription

  action_fallback KumpelBackWeb.Subscription.FallbackController

  @spec subscribe(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def subscribe(conn, %{"code" => _code, "name" => _name} = params) do
    with {:ok, message} <- Subscription.subscribe(conn.assigns.user_id, params) do
      conn
      |> put_status(:ok)
      |> render(:subscribe, message: message)
    end
  end
end
