defmodule KumpelBack.Users.Verify do
  alias KumpelBack.Users
  alias Users.User

  alias KumpelBack.Repo

  def call(%{"mail" => mail, "password" => password}) do
    case get_by_email(mail) do
      {:ok, user} -> verify(user, password)
      {:error, _} = error -> error
    end
  end

  defp verify(user, password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end

  defp get_by_email(mail) do
    case Repo.get_by(User, mail: mail) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end
end
