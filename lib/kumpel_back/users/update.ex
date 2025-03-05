defmodule KumpelBack.Users.Update do
  @moduledoc false

  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  def call(%{"id" => id} = params) do
    case Repo.get(User, id) do
	  nil -> {:error, :not_found}
	  user -> update(user, params)	
	end

  end

  def update(user, params) do
	user
	|> User.changeset(params)
	|> Repo.update()
	|> case do
      {:ok, user} ->
        # Preload associations here so the controller doesn't need to handle it
        {:ok, Repo.preload(user, [created_rooms: [:subscribers]])}

      error ->
        error
    end
  end
	
end
