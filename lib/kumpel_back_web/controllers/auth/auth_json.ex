defmodule KumpelBackWeb.Auth.AuthJSON do
  @moduledoc """
    This module contains all view functions for Auth
  """

  @doc """
  Renders the signed token
  """
  def login(%{token: token, refresh_token: refresh_token}) do
    %{
      status: "Authorized",
      token: token,
      refresh: refresh_token
    }
  end
end
