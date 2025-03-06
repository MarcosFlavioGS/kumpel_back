defmodule KumpelBack.Rooms.GetInfo do
  @moduledoc """
  Gets info about a chat room and sends it back
  """

  alias KumpelBack.Rooms
  alias Rooms.Room

  def get(%{"id" => id}) when id == "lobby" do
    {:ok, %Room{name: "Lobby"}}
  end

  def get(%{"id" => id}) do
    case Rooms.get(id) do
      # TODO: Return complete room info
      {:ok, %Room{name: room_name}} -> {:ok, room_name}
      {:error, :not_found} -> {:error, "Room not found"}
      _ -> {:error, "Some error"}
    end
  end
end
