defmodule KumpelBack.Users.Update do
  @moduledoc false

  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  @spec call(map()) ::
          {:ok, User.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  def call(%{"id" => id} = params) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> update(user, params)
    end
  end

  @spec update(User.t(), map()) ::
          {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update(user, params) do
    user
    |> User.changeset(params)
    |> Repo.update()
    |> case do
      {:ok, user} ->
        # Preload associations here so the controller doesn't need to handle it
        {:ok, Repo.preload(user, [:created_rooms, :subscribed_rooms])}

      error ->
        error
    end
  end
end
