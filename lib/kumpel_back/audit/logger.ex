defmodule KumpelBack.Audit.Logger do
  @moduledoc """
  Module for audit logging of sensitive operations
  """

  require Logger

  @doc """
  Logs a security event with relevant details.
  """
  def log_security_event(event_type, user_id, details) do
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()
    ip = get_ip_address()
    user_agent = get_user_agent()

    log_entry = %{
      timestamp: timestamp,
      event_type: event_type,
      user_id: user_id,
      ip_address: ip,
      user_agent: user_agent,
      details: details
    }

    Logger.info("SECURITY EVENT: #{Jason.encode!(log_entry)}")
    persist_log(log_entry)
  end

  @doc """
  Logs a failed login attempt.
  """
  def log_failed_login(user_id, reason) do
    log_security_event("failed_login", user_id, %{
      reason: reason,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  @doc """
  Logs a successful login.
  """
  def log_successful_login(user_id) do
    log_security_event("successful_login", user_id, %{
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  @doc """
  Logs a room access attempt.
  """
  def log_room_access(room_id, success, reason) do
    log_security_event("room_access", "", %{
      room_id: room_id,
      success: success,
      reason: reason,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  @doc """
  Logs a user creation.
  """
  def log_user_creation(user_id, created_by) do
    log_security_event("user_creation", user_id, %{
      created_by: created_by,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  @doc """
  Logs a user deletion.
  """
  def log_user_deletion(user_id, deleted_by) do
    log_security_event("user_deletion", user_id, %{
      deleted_by: deleted_by,
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end

  defp get_ip_address do
    #TODO: This should be implemented to get the actual IP address from the connection
    # For now, returning a placeholder
    "127.0.0.1"
  end

  defp get_user_agent do
    # TODO: This should be implemented to get the actual user agent from the connection
    # For now, returning a placeholder
    "Unknown"
  end

  defp persist_log(_log_entry) do
    # TODO: This should be implemented to persist logs to a secure storage
    # For now, just logging to console
    :ok
  end
end
