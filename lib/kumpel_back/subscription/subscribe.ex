defmodule KumpelBack.Subscription.Subscribe do
  @moduledoc """
  Module to subscribe users to rooms
  """
  alias KumpelBack.Repo
  alias KumpelBack.Users.User
  alias KumpelBack.Rooms.Room
  import Ecto.Query

  def call(user, params) do
    with {:ok, user} <- get_user(user),
         {:ok, room} <- get_room_by_code_and_name(params["code"], params["name"]),
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

  defp get_room_by_code_and_name(code, name) when is_binary(code) and is_binary(name) do
    case Repo.one(from r in Room, where: r.code == ^code and r.name == ^name) do
      nil -> {:error, "Room not found with given code and name"}
      room -> {:ok, room}
    end
  end

  defp get_room_by_code_and_name(_, _), do: {:error, "Code and name are required"}

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
