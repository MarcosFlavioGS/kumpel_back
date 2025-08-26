defmodule KumpelBack.Users.Get do
  @moduledoc """
  	Module to get an user
  """

  import Ecto.Query, warn: false
  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  @doc """
  	Retrieves an User
  """
  def call(id) do
    query = from u in User,
      where: u.id == ^id,
      left_join: sr in assoc(u, :subscribed_rooms),
      left_join: srs in assoc(sr, :subscribers),
      left_join: cr in assoc(u, :created_rooms),
      left_join: crs in assoc(cr, :subscribers),
      preload: [
      subscribed_rooms: {sr, subscribers: srs},
      created_rooms: {cr, subscribers: crs}
      ],
      select: u

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end
end
