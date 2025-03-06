defmodule KumpelBackWeb.Users.UsersController do
  @moduledoc """
  	Module for users controller
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Users
  alias Users.User

  action_fallback KumpelBackWeb.Users.FallbackController

  @doc """
  create/2

  params:
  - conn: Plug.cond do
  - params: %User{}
  end
  """
  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  @doc """
  update/2

  params:
  - conn: Plug.conn
  - %{"id" => id, ..params}
  """
  def update(conn, params) do
    with {:ok, %User{} = user} <- Users.update(params) do
      conn
      |> put_status(:ok)
      |> render(:update, user: user)
    end
  end

  @doc """
  show/2

  params:
  - conn: Plug.conn
  - %{"id" => id}
  """
  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get, user: user)
    end
  end

  @doc """
  index/1

  params:
  - conn: Plug.conn
  """
  def index(conn, _) do
    with {:ok, users} <- Users.list() do
      conn
      |> put_status(:ok)
      |> render(:get, users: users)
    end
  end

  @doc """
  Delete/2

  params:
  - conn: Plug.conn
  - %{"id" => id}
  """
  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, user: user)
    end
  end
end
