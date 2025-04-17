defmodule KumpelBack.Rooms.Create do
  @moduledoc false

  alias KumpelBack.Rooms.Room
  alias KumpelBack.Repo

  def call(params, user_id) do
    params = Map.put(params, "adm_id", user_id)

    params
    |> Room.changeset()
    |> Repo.insert()
    |> case do
      {:ok, room} ->
        # Preload associations here so the controller doesn't need to handle it
        {:ok, Repo.preload(room, [:subscribers])}

      error ->
        error
    end
  end
end
