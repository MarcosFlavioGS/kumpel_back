defmodule KumpelBack.Subscription do
  @moduledoc """
  Facades to subscription module
  """
  alias KumpelBack.Subscription.Subscribe

  defdelegate subscribe(user, room_id), to: Subscribe, as: :call
end
