defmodule KumpelBackWeb.Token do
  @moduledoc """
  Module to sign and verify tokens
  """

  alias KumpelBackWeb.Endpoint
  alias Phoenix.Token

  @sign_salt "Kumpel_User"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id, user_mail: user.mail})
  end

  def verify(token), do: Token.verify(Endpoint, @sign_salt, token)
end
