defmodule KumpelBackWeb.Rooms.RoomsController do
  @moduledoc """
  Module for Rooms controller functions
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Rooms
  alias Rooms.Room

  action_fallback KumpelBackWeb.Rooms.FallbackController

  @doc """
  create/2

  params:
  - conn: Plug.cond do
  - params: %Room{}
  end
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, %Room{} = room} <- Rooms.create(params, conn.assigns.user_id.user_id) do
      conn
      |> put_status(:created)
      |> render(:create, room: room)
    end
  end

  @doc """
  update/2

  params:
  - conn: Plug.conn
  - %{"id" => id, ..params}
  """
  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, params) do
    with {:ok, room} <- Rooms.update(params) do
      conn
      |> put_status(:ok)
      |> render(:update, room: room)
    end
  end

  @doc """
  show/2

  params:
  - conn: Plug.conn
  - %{"id" => id}
  """
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, %Room{} = room} <- Rooms.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get, room: room)
    end
  end

  @doc """
  index/1

  params:
  - conn: Plug.conn
  """
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{}) do
    with {:ok, [%Room{} | _] = rooms} <- Rooms.list() do
      conn
      |> put_status(:ok)
      |> render(:get, rooms: rooms)
    end
  end

  @doc """
  Delete/2

  params:
  - conn: Plug.conn
  - %{"id" => id}
  """
  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    with {:ok, %Room{} = room} <- Rooms.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, room: room)
    end
  end
end
