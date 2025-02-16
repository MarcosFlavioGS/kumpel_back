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
      data: user
    }
  end

  @doc """
  get/1
  renders multiple Users
  """
  def get(%{users: users}) do
    %{
      users: users
    }
  end
end
