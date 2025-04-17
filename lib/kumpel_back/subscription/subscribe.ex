defmodule KumpelBack.Subscription.Subscribe do
  @moduledoc """
  Module to subscribe users to rooms
  """
  alias KumpelBack.Repo
  alias KumpelBack.Users.User
  alias KumpelBack.Rooms.Room

  def call(user, room_id) do
    with _user <- Repo.get(User, user.user_id),
         _room <- Repo.get(Room, room_id) do
      # TODO: check if already subscribed
      # TODO: Add the subscription to DataBase
      # TODO: Handle errors
      {:ok, "Subscribed !"}
    else
      nil -> {:error, "User or Room not found"}
    end
  end
end
