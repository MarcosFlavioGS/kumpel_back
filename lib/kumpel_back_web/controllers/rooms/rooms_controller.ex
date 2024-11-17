defmodule KumpelBackWeb.Rooms.RoomsController do
  use KumpelBackWeb, :controller

  alias KumpelBack.Rooms
  alias Rooms.Room

  action_fallback KumpelBackWeb.Rooms.FallbackController

  @doc """
    Creates a new chat room
  """
  def create conn, params do
    with {:ok, %Room{} = room} <- Rooms.create(params) do
    	conn
      |> put_status(:created)
      |> render(:create, room: room)
    end
  end

  def update conn, _params do
    # TODO: Updates a chat room
    conn
    |> put_status(:ok)
  end

  def delete conn, _params do
    # TODO: Deletes a chat room
    conn
    |> put_status(:ok)
  end

  def show conn, _params do
    # TODO: List all chat rooms
    conn
    |> put_status(:ok)
  end
end