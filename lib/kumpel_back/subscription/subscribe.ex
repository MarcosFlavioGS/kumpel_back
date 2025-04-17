defmodule KumpelBack.Subscription.Subscribe do
  @moduledoc """
  Module to subscribe users to rooms
  """

  def call(user_id, room_id) do
    # TODO: Check is room exist
	# TODO: Chack if the user exist
	# TODO: Check if the user is already subscribed
	# TODO: Add the subscription to DataBase
	# TODO: Handle errors
	{:ok, "Subscribed !"}
  end
	
end
