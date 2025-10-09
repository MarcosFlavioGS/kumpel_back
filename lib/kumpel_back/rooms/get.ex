defmodule KumpelBack.Rooms.Get do
  @moduledoc """
    Contains call/1 which gets a Room from the DB
  """

  import Ecto.Query, warn: false
  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  @doc """
    call/1 Receives a room id and returns the room
    returns nill if non room is found
  """
  def call(id) do
    query =
      from r in Room,
        where: r.id == ^id,
        left_join: ad in assoc(r, :adm),
        left_join: sb in assoc(r, :subscribers),
        preload: [
          adm: ad,
          subscribers: sb
        ],
        select: r

    case Repo.one(query) do
      nil -> {:error, :not_found}
      room -> {:ok, room}
    end
  end
end
