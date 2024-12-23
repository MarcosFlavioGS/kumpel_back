defmodule KumpelBackWeb.Rooms.RoomsJSON do
  @moduledoc """
    This module contains all view functions for CREATE SHOW UPDATE DELETE
  """

  @doc """
    create/1
    Receives an room struct and returns the map containing a message, the room and the room id.
    data
  """
  def create(%{room: room}) do
    %{
      message: "Room created !",
      id: room.id,
      data: room
    }
  end

  @doc """
  get/1
  Renders a single Room
  """
  def get(%{room: room}) do
    %{
      id: room.id,
      data: room
    }
  end

  @doc """
  get/1
  renders multiple Rooms
  """
  def get(%{rooms: rooms}) do
    %{
      rooms: rooms
    }
  end
end
