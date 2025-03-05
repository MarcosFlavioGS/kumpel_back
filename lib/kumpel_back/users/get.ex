defmodule KumpelBack.Users.Get do
	@moduledoc """
		Module to get an user
	"""

  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  @doc """
  	Retrieves an User
  """
  def call(id) do
		case Repo.get(User, id) do
			nil -> {:error, :not_found}
	  	user ->
				{:ok, Repo.preload(user, [subscribed_rooms: :subscribers, created_rooms: :subscribers])}
		end
  end
  
end
