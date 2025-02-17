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

  def show(conn, _params) do
    # TODO: gets an user
    conn
    |> put_status(:ok)
  end

  def update(conn, _params) do
    # TODO: Updates an user
    conn
    |> put_status(:ok)
  end

  def delete(conn, _params) do
    # TODO: Deletes an user
    conn
    |> put_status(:ok)
  end
end
