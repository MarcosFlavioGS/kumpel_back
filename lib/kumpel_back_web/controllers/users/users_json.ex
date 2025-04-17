defmodule KumpelBackWeb.Users.UsersJSON do
  @moduledoc """
    This module contains all view functions for CREATE SHOW UPDATE DELETE
  """

  @doc """
    create/1
    Receives an user struct and returns the map containing a message, the user and the room id.
    data
  """
  def create(%{user: user}) do
    %{
      message: "User created !",
      id: user.id,
      data: user
    }
  end

  @doc """
  get/1
  Renders a single User
  """
  def get(%{user: user}) do
    %{
      id: user.id,
      name: user.name,
      mail: user.mail,
      created_rooms:
        Enum.map(user.created_rooms, fn room ->
          %{
            name: room.name,
            room_id: room.id,
            code: room.code
          }
        end),
      subscribed_rooms:
        Enum.map(user.subscribed_rooms, fn room ->
          %{
            name: room.name,
            room_id: room.id,
            code: room.code
          }
        end)
    }
  end

  @doc """
  get/1
  renders multiple Users
  """
  def get(%{users: users}) do
    %{
      users:
        Enum.map(users, fn user ->
          %{
            user_id: user.id,
            name: user.name,
            mail: user.mail,
            created_rooms:
              Enum.map(user.created_rooms, fn room ->
                %{
                  name: room.name,
                  room_id: room.id,
                  code: room.code
                }
              end),
            subscribed_rooms:
              Enum.map(user.subscribed_rooms, fn room ->
                %{
                  name: room.name,
                  room_id: room.id,
                  code: room.code
                }
              end)
          }
        end)
    }
  end

  @doc """
  Renders the updated user
  """
  def update(%{user: user}) do
    %{
      user_id: user.id,
      name: user.name,
      mail: user.mail,
      created_rooms:
        Enum.map(user.created_rooms, fn room ->
          %{
            name: room.name,
            room_id: room.id,
            code: room.code
          }
        end),
      subscribed_rooms:
        Enum.map(user.subscribed_rooms, fn room ->
          %{
            name: room.name,
            room_id: room.id,
            code: room.code
          }
        end)
    }
  end

  @doc """
  Renders the deleted user
  """
  def delete(%{user: user}) do
    %{
      message: "User deleted !",
      user_id: user.id
    }
  end
end
