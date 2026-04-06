defmodule KumpelBackWeb.Auth.AuthController do
  @moduledoc """
  Module with all auth controllers
  """

  use KumpelBackWeb, :controller

  alias KumpelBack.Users
  alias Users.User
  alias KumpelBackWeb.Token
  alias KumpelBack.Audit.Logger

  action_fallback KumpelBackWeb.Auth.FallbackController

  @max_attempts 5
  # 5 minutes in seconds
  @lockout_duration 300

  @doc """
  login/2

  params:
  - conn: Plug.conn
  - %{"mail" => mail, "password" => password}
  """
  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login(conn, params) do
    case check_rate_limit(params["mail"]) do
      :ok ->
        with {:ok, %User{} = user} <- Users.login(params) do
          token = Token.sign(user)
          refresh_token = Token.sign_refresh(user)

          # Log successful login
          Logger.log_successful_login(user.id)

          conn
          |> put_status(:ok)
          |> render(:login, %{token: token, refresh_token: refresh_token})
        end

      :error ->
        # Log failed login attempt
        Logger.log_failed_login(params["mail"], "Rate limit exceeded")

        conn
        |> put_status(:too_many_requests)
        |> put_view(json: KumpelBackWeb.Auth.ErrorJSON)
        |> render(:error, message: "Too many login attempts. Please try again later.")
    end
  end

  @doc """
  Exchanges a valid refresh token for a new access token and refresh token.

  JSON body: `%{"refresh" => "<refresh_token>"}` (same key as in the login response).
  """
  @spec refresh(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def refresh(conn, params) do
    with {:ok, refresh} <- fetch_refresh_param(params),
         {:ok, claims} <- verify_refresh_token(refresh),
         {:ok, %User{} = user} <- Users.get(claims.user_id),
         :ok <- verify_mail_match(user, claims) do
      token = Token.sign(user)
      refresh_token = Token.sign_refresh(user)

      conn
      |> put_status(:ok)
      |> render(:refresh, %{token: token, refresh_token: refresh_token})
    end
  end

  @spec fetch_refresh_param(map()) :: {:ok, String.t()} | {:error, :missing_refresh}
  defp fetch_refresh_param(%{"refresh" => refresh}) when is_binary(refresh) do
    if String.trim(refresh) == "" do
      {:error, :missing_refresh}
    else
      {:ok, refresh}
    end
  end

  defp fetch_refresh_param(_), do: {:error, :missing_refresh}

  @spec verify_refresh_token(String.t()) :: {:ok, Token.claims()} | {:error, :invalid_refresh}
  defp verify_refresh_token(token) do
    case Token.verify_refresh(token) do
      {:ok, claims} -> {:ok, claims}
      _ -> {:error, :invalid_refresh}
    end
  end

  @spec verify_mail_match(User.t(), Token.claims()) :: :ok | {:error, :unauthorized}
  defp verify_mail_match(%User{mail: mail}, claims) do
    if claims.user_mail == mail do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  defp check_rate_limit(email) do
    key = "login_attempts:#{email}"
    attempts = get_attempts(key)

    if attempts >= @max_attempts do
      :error
    else
      increment_attempts(key)
      :ok
    end
  end

  defp get_attempts(key) do
    case Cachex.get(:rate_limit_cache, key) do
      {:ok, nil} -> 0
      {:ok, attempts} -> attempts
      _ -> 0
    end
  end

  defp increment_attempts(key) do
    attempts = get_attempts(key) + 1
    Cachex.put(:rate_limit_cache, key, attempts, ttl: @lockout_duration)
  end
end
