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
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, user} = result ->
        Logger.log_user_creation(user.id, "system")
        # Preload associations here so the controller doesn't need to handle it
        {:ok, Repo.preload(user, [:created_rooms, :subscribed_rooms])}

      error ->
        error
    end
  end
end
