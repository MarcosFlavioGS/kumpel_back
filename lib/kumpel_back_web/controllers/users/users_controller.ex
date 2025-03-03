defmodule KumpelBackWeb.Users.UsersController do
  @moduledoc """
  	Module for users controller
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Users
  alias Users.User

  action_fallback KumpelBackWeb.Rooms.FallbackController

  @doc """
  	Creates a user
  """
  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  @doc """
    Gets an user
  """
  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get, user: user)
    end
  end

  @doc """
    Updates an user
  """
  def update(conn, _params) do
    # TODO: Updates an user
    conn
    |> put_status(:ok)
  end

  @doc """
    Deletes an user
  """
  def delete(conn, _params) do
    # TODO: Deletes an user
    conn
    |> put_status(:ok)
  end
end
