defmodule KumpelBack.Subscription.Subscribe do
  @moduledoc """
  Module to subscribe users to rooms
  """
  alias KumpelBack.Repo
  alias KumpelBack.Users.User
  alias KumpelBack.Rooms.Room

  def call(user, room_id) do
    with {:ok, user} <- get_user(user),
         {:ok, room} <- get_room(room_id),
         {:ok, _} <- check_subscription(user, room) do
      subscribe_user(user, room)
    end
  end

  defp get_user(user) do
    case Repo.get(User, user.user_id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  defp get_room(room_id) do
    case Repo.get(Room, room_id) do
      nil -> {:error, "Room not found"}
      room -> {:ok, room}
    end
  end

  defp check_subscription(user, room) do
    user = Repo.preload(user, :subscribed_rooms)

    if Enum.any?(user.subscribed_rooms, fn subscribed_room -> subscribed_room.id == room.id end) do
      {:error, "User is already subscribed to this room"}
    else
      {:ok, user}
    end
  end

  defp subscribe_user(user, room) do
    user = Repo.preload(user, :subscribed_rooms)

    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:subscribed_rooms, [room | user.subscribed_rooms])
    |> Repo.update()
    |> case do
      {:ok, _} -> {:ok, "Successfully subscribed to room"}
      {:error, _} -> {:error, "Failed to subscribe to room"}
    end
  end
end
