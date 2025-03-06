defmodule KumpelBack.Rooms.Update do
  @moduledoc """
  Module to update a Room
  """

  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  def call(%{"id" => id} = params) do
    case Repo.get(Room, id) do
      nil -> {:error, :not_found}
      room -> update(room, params)
    end
  end

  def update(room, params) do
    room
    |> Room.changeset(params)
    |> Repo.update()
    |> case do
      {:ok, room} -> {:ok, Repo.preload(room, [:adm, :subscribers])}
      error -> error
    end
  end
end
