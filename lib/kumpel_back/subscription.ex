defmodule KumpelBack.Subscription do
  @moduledoc """
  Facades to subscription module
  """
  alias KumpelBack.Subscription.Subscribe

  defdelegate subscribe(user, params), to: Subscribe, as: :call
end
