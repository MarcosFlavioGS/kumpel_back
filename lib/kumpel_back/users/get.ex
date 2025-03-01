defmodule KumpelBack.Users.Get do
  @moduledoc false

  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  @doc """
  	Retrieves an User
  """
  def call(id) do
		case Repo.get(User, id) do
			nil -> {:error, :not_found}
	  	user -> {:ok, Repo.preload(user, [:created_rooms, :subscribed_rooms])}
		end
  end
  
end
