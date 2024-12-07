defmodule KumpelBack.Rooms.GetInfo do
  @moduledoc false

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
