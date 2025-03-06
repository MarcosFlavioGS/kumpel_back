defmodule KumpelBack.Users.List do
  @moduledoc false

  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  def call() do
    case Repo.all(User) do
      [] -> {:error, :not_found}
      users -> {:ok, Repo.preload(users, [:created_rooms, :subscribed_rooms])}
    end
  end
end
