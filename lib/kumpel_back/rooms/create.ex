defmodule KumpelBack.Rooms.Create do
  @moduledoc false

  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  def call(params) do
    params
    |> Room.changeset()
    |> Repo.insert()
  end
end
