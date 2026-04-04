defmodule KumpelBack.Subscription do
  @moduledoc """
  Facades to subscription module
  """
  alias KumpelBack.Subscription.Subscribe

  @spec subscribe(map(), map()) :: {:ok, String.t()} | {:error, String.t()}
  defdelegate subscribe(user, params), to: Subscribe, as: :call
end
