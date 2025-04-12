defmodule KumpelBackWeb.Rooms.RoomsJSON do
  @moduledoc """
    This module contains all view functions for CREATE SHOW UPDATE DELETE
  """

  @doc """
  Renders the created room
  """
  def create(%{room: room}) do
    %{
      message: "Room created !",
      id: room.id,
      data: room
    }
  end

  @doc """
  Renders the updated room
  """
  def update(%{room: room}) do
    %{
      message: "Room updated !",
      id: room.id,
      name: room.name,
      code: room.code,
      adm: %{
        id: room.adm_id,
        name: room.adm.name,
        mail: room.adm.mail
      },
      subscribers:
        Enum.map(room.subscribers, fn sub ->
          %{
            sub_id: sub.id,
            name: sub.name,
            mail: sub.mail
          }
        end)
    }
  end

  @doc """
  get/1
  Renders a single Room
  """
  def get(%{room: room}) do
    %{
      id: room.id,
      name: room.name,
      code: room.code,
      adm: %{
        id: room.adm_id,
        name: room.adm.name,
        mail: room.adm.mail
      },
      subscribers:
        Enum.map(room.subscribers, fn sub ->
          %{
            sub_id: sub.id,
            name: sub.name,
            mail: sub.mail
          }
        end)
    }
  end

  @doc """
  renders multiple Rooms
  """
  def get(%{rooms: rooms}) do
    Enum.map(rooms, fn room ->
      %{
        id: room.id,
        name: room.name,
        code: room.code,
        adm: %{
          id: room.adm_id,
          name: room.adm.name,
          mail: room.adm.mail
        },
        subscribers:
          Enum.map(room.subscribers, fn sub ->
            %{
              sub_id: sub.id,
              name: sub.name,
              mail: sub.mail
            }
          end)
      }
    end)
  end

  @doc """
  Renders the deleted room
  """
  def delete(%{room: room}) do
    %{
      message: "Room deleted",
      id: room.id,
      name: room.name
    }
  end
end
