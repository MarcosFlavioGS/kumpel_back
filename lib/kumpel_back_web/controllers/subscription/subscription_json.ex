defmodule KumpelBackWeb.Subscription.SubscriptionJSON do
  @moduledoc """
  Views for subscriptions
  """

  @doc """
  Renders a succesful subscription attempt
  """
  @spec subscribe(map()) :: map()
  def subscribe(%{message: message}) do
    %{
      status: :ok,
      message: message
    }
  end
end
