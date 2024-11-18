defmodule KumpelBack.Rooms.Authorize do
	@moduledoc """
		Module responsable to authorize channel connections
	"""

  alias KumpelBack.Rooms
  alias Rooms.Room

  def authorized(room_id, %{"code" => code}) do
		with {:ok, %Room{code: room_code}} <- Rooms.get(room_id), true <- room_code == code do
			{:ok, "Welcome to chat"}
		else
			false -> {:error, "Invalid code"}
  		_ -> {:error, "Room not found"}
		end
  end

  def authorized(_room_id, %{}), do: {:error, "Invalid or empty code"}
  def authorized("lobby"), do: {:ok, "Welcome to lobby"}
  def authorized(), do: {:error, "Room id and code not provided"}
end
