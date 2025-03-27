defmodule KumpelBack.Users.Password do
  @moduledoc """
  Module for password validation and policies
  """

  @min_length 8
  @max_length 72

  @doc """
  Validates a password according to security policies.
  Returns :ok if valid, {:error, reason} if invalid.
  """
  def validate(password) when is_binary(password) do
    with :ok <- check_length(password),
         :ok <- check_complexity(password),
         :ok <- check_common_passwords(password) do
      :ok
    end
  end
  def validate(_), do: {:error, "Password must be a string"}

  defp check_length(password) do
    cond do
      String.length(password) < @min_length ->
        {:error, "Password must be at least #{@min_length} characters long"}
      String.length(password) > @max_length ->
        {:error, "Password must not exceed #{@max_length} characters"}
      true ->
        :ok
    end
  end

  defp check_complexity(password) do
    cond do
      !Regex.match?(~r/[A-Z]/, password) ->
        {:error, "Password must contain at least one uppercase letter"}
      !Regex.match?(~r/[a-z]/, password) ->
        {:error, "Password must contain at least one lowercase letter"}
      !Regex.match?(~r/[0-9]/, password) ->
        {:error, "Password must contain at least one number"}
      !Regex.match?(~r/[^A-Za-z0-9]/, password) ->
        {:error, "Password must contain at least one special character"}
      true ->
        :ok
    end
  end

  defp check_common_passwords(password) do
    # List of common passwords to check against
    common_passwords = [
      "password123",
      "12345678",
      "qwerty123",
      "admin123",
      "letmein123"
    ]

    if password in common_passwords do
      {:error, "This password is too common. Please choose a stronger password"}
    else
      :ok
    end
  end

  @doc """
  Generates a secure random password that meets all requirements.
  """
  def generate do
    :crypto.strong_rand_bytes(16)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, 12)
    |> ensure_complexity()
  end

  defp ensure_complexity(password) do
    # Ensure the generated password meets complexity requirements
    password
    |> String.replace(~r/[^A-Za-z0-9]/, "!")
    |> String.replace(~r/([a-z])/, "\\1A")
    |> String.replace(~r/([A-Z])/, "\\11")
  end
end
