defmodule KumpelBack.Users.Create do
  @moduledoc """
    Module that contains creation logic for the user
  """

  alias KumpelBack.Users.User
  alias KumpelBack.Repo
  alias KumpelBack.Audit.Logger

  @doc """
  	Creates an user
  """
  def call(params) do
    changeset = User.changeset(params)

    case changeset.valid? do
      true ->
        case Repo.insert(changeset) do
          {:ok, user} ->
            Logger.log_user_creation(user.id, "system")
            {:ok, Repo.preload(user, [:created_rooms, :subscribed_rooms])}

          {:error, changeset} ->
            {:error, changeset}
        end

      false ->
        {:error, changeset}
    end
  end
end
