defmodule KumpelBack.Rooms.List do
  @moduledoc """
  Module to list Rooms.
  """

  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  @doc """
  Lists all Rooms in DB.
  """
  def call() do
    case Repo.all(Room) do
      [] -> {:error, :not_found}
      rooms -> {:ok, Repo.preload(rooms, [:adm, :subscribers])}
    end
  end
end
