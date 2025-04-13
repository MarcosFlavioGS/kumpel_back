defmodule KumpelBackWeb.Token do
  @moduledoc """
  Module to sign and verify tokens
  """

  alias KumpelBackWeb.Endpoint
  alias Phoenix.Token

  @sign_salt "Kumpel_User"
  @refresh_salt "Kumpel_Refresh"
  # 1 hour in seconds
  @access_token_expiry 3600
  # 30 days in seconds
  @refresh_token_expiry 2_592_000

  @doc """
  Signs a new access token for a user.
  """
  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{
      user_id: user.id,
      user_mail: user.mail,
      exp: System.system_time(:second) + @access_token_expiry
    })
  end

  @doc """
  Signs a new refresh token for a user.
  """
  def sign_refresh(user) do
    Token.sign(Endpoint, @refresh_salt, %{
      user_id: user.id,
      user_mail: user.mail,
      exp: System.system_time(:second) + @refresh_token_expiry
    })
  end

  @doc """
  Verifies an access token and checks its expiration.
  Returns {:ok, data} if valid, {:error, reason} if invalid.
  """
  def verify(token) do
    case Token.verify(Endpoint, @sign_salt, token, max_age: @access_token_expiry) do
      {:ok, data} -> {:ok, data}
      {:error, :expired} -> {:error, :expired}
      error -> error
    end
  end

  @doc """
  Verifies a refresh token and checks its expiration.
  Returns {:ok, data} if valid, {:error, reason} if invalid.
  """
  def verify_refresh(token) do
    case Token.verify(Endpoint, @refresh_salt, token, max_age: @refresh_token_expiry) do
      {:ok, data} -> {:ok, data}
      {:error, :expired} -> {:error, :expired}
      error -> error
    end
  end
end
