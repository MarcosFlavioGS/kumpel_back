defmodule KumpelBack.Users.Delete do
  @moduledoc """
    Contains call/1 which gets an user from the DB
  """
  alias KumpelBack.Users.User
  alias KumpelBack.Repo
  alias KumpelBack.Audit.Logger

  @doc """
    call/1 Receives an user id from the controller.
  """
  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, "User not found"}
      user ->
        Repo.delete(user)
        |> case do
          {:ok, user} = result ->
            Logger.log_user_deletion(user.id, "system")
            result
          error -> error
        end
    end
  end
end
