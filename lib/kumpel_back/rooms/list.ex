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
      rooms -> {:ok, rooms}
      _ -> {:error, :not_found}
    end
  end
end
