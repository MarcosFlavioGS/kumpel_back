defmodule KumpelBackWeb.Users.UsersController do
  @moduledoc false

  use KumpelBackWeb, :controller

  alias KumpelBack.Users
  alias Users.User

  action_fallback KumpelBackWeb.Rooms.FallbackController

  def create(conn, params) do
   with {:ok, %User{} = user} <- Users.create(params) do
	 conn
	 |> put_status(:created)
     |> render(:create, user: user)
   end
  end

  def show() do
    #
  end

  def update() do
	#
  end

  def delete() do
	#
  end
	
end
