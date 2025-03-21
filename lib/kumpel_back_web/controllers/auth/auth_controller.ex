defmodule KumpelBackWeb.Auth.AuthController do
  @moduledoc """
  Module with all auth controllers
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Users
  alias Users.User

  alias KumpelBackWeb.Token

  action_fallback KumpelBackWeb.Auth.FallbackController

  @doc """
  login/2

  params:
  - conn: Plug.conn
  - %{"mail" => mail, "password" => password}
  """
  def login(conn, params) do
    with {:ok, %User{} = user} <- Users.login(params) do
      token = Token.sign(user)

      conn
      |> put_status(:ok)
      |> render(:login, token: token)
    end
  end
end
