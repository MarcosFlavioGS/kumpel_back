defmodule KumpelBack.Rooms.Get do
  @moduledoc """
    Contains call/1 which gets a Room from the DB
  """
  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  @doc """
    call/1 Receives a room id and returns the room
    returns nill if non room is found
  """
  def call(id) do
    case Repo.get(Room, id) do
      nil -> {:error, :not_found}
      room -> {:ok, room}
    end
  end
end
