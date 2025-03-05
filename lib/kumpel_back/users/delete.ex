defmodule KumpelBack.Users.Delete do
  @moduledoc """
    Contains call/1 which gets an user from the DB
  """
  alias KumpelBack.Users.User
  alias KumpelBack.Repo

  @doc """
    call/1 Receives an user id from the controller.
  """
  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
