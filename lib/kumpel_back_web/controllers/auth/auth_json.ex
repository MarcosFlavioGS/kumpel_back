defmodule KumpelBackWeb.Auth.AuthJSON do
  @moduledoc """
    This module contains all view functions for Auth
  """

  @doc """
  Renders the signed token
  """
  def login(%{token: token}) do
    %{
      status: "Authorized",
      token: token
    }
  end
end
