defmodule KumpelBackWeb.Auth.AuthJSON do
  @moduledoc """
    This module contains all view functions for Auth
  """

  @doc """
  Renders the signed token
  """
  @spec login(map()) :: map()
  def login(%{token: token, refresh_token: refresh_token}) do
    %{
      status: "Authorized",
      token: token,
      refresh: refresh_token
    }
  end

  @spec refresh(map()) :: map()
  def refresh(%{token: token, refresh_token: refresh_token}) do
    %{
      token: token,
      refresh: refresh_token
    }
  end
end
