defmodule KumpelBackWeb.Subscription.ErrorJSON do
  @moduledoc """
  Renders error jsons for subscriptions
  """

  def error(%{status: status, message: message}) do
    %{
      status: status,
      message: message
    }
  end
end
