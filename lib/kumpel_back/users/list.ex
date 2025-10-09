defmodule KumpelBack.Users.List do
  @moduledoc false

  import Ecto.Query, warn: false
  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  def call() do
    query =
      from u in User,
        left_join: cr in assoc(u, :created_rooms),
        left_join: sr in assoc(u, :subscribed_rooms),
        preload: [
          created_rooms: cr,
          subscribed_rooms: sr
        ],
        select: u

    case Repo.all(query) do
      [] -> {:error, :not_found}
      users -> {:ok, users}
    end
  end
end
