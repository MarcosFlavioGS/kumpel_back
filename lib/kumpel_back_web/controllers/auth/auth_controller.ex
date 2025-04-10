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

  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-methods", "POST, OPTIONS")
    |> send_resp(200, "")
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
