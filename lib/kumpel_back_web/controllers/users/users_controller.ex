defmodule KumpelBackWeb.Users.UsersController do
  @moduledoc """
  	Module for users controller functions
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Users
  alias Users.User

  alias KumpelBackWeb.Token
  alias KumpelBack.Audit.Logger

  action_fallback KumpelBackWeb.Users.FallbackController

  @doc """
  create/2

  params:
  - conn: Plug.cond do
  - params: %User{}
  end
  """
  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create(params) do
      token = Token.sign(user)

      Logger.log_successful_login(user.id)

      conn
      |> put_status(:created)
      |> render(:create, %{user: user, token: token})
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
  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get, user: user)
    end
  end

  @doc """
  current/2

  params:
  - conn: Plug.conn
  - _params
  """
  @spec current(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def current(conn, _params) do
    with {:ok, %User{} = user} <- Users.get(conn.assigns.user_id.user_id) do
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
  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
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
  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, user: user)
    end
  end
end
