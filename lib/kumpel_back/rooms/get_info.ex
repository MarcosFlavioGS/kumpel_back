defmodule KumpelBack.Rooms.GetInfo do
  @moduledoc """
  Gets info about a chat room and sends it back
  """

  alias KumpelBack.Rooms
  alias Rooms.Room

  def get %{"id" => id} = payload do
    with {:ok, %Room{name: room_name}} <- Rooms.get(id) do
			{:ok, room_name}
		else
			{:error, :not_found} -> {:error, "Room not found"}
		_ -> {:error, "Some error"}
		end
  end

end
