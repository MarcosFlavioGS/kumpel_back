defmodule KumpelBack.Rooms.Delete do
  @moduledoc """
  Module to delete a Room
  """

  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  @doc """
  Deletes a Room
  """
  @spec call(String.t()) ::
          {:ok, Room.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  def call(id) do
    case Repo.get(Room, id) do
      nil -> {:error, :not_found}
      room -> Repo.delete(room)
    end
  end
end
