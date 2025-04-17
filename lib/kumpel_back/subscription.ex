defmodule KumpelBack.Subscription do
  @moduledoc """
  Facades to subscription module
  """
  alias KumpelBack.Subscription.Subscribe

  defdelegate subscribe(user_id, room_id), to: Subscribe, as: :call 
	
end
