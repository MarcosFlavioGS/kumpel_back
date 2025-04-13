defmodule KumpelBackWeb.ChatRoomChannel do
  @moduledoc """
    This is the module responsable for the chat_room:* channel.
  """

  use KumpelBackWeb, :channel
  alias KumpelBack.Rooms.Authorize
  alias KumpelBack.Rooms.GetInfo
  alias KumpelBack.Audit.Logger

  @max_message_length 1000
  @max_messages_per_minute 30
  @max_connections_per_room 100

  @doc """
    This is the join function to the main room called lobby. It is free for all and does not need authentication.
  """
  @impl true
  def join("chat_room:lobby", _payload, socket) do
    case check_connection_limit("lobby") do
      :ok ->
        case Authorize.authorized("lobby") do
          {:ok, _message} ->
            Logger.log_room_access(
              "lobby",
              true,
              "Successfully joined lobby"
            )

            {:ok, socket}

          {:error, message} ->
            Logger.log_room_access("lobby", false, message)
            {:error, %{reason: message}}
        end

      :error ->
        Logger.log_room_access(socket.assigns.user_id, "lobby", false, "Room is full")
        {:error, %{reason: "Room is full"}}
    end
  end

  @doc """
    This endpoint checks for an existing room on the DB and return the socket if the provided code is valid.
  """
  @impl true
  def join("chat_room:" <> room_id, payload, socket) do
    case check_connection_limit(room_id) do
      :ok ->
        case Authorize.authorized(room_id, payload) do
          {:ok, _message} ->
            Logger.log_room_access(
              room_id,
              true,
              "Successfully joined room"
            )

            {:ok, socket}

          {:error, message} ->
            Logger.log_room_access(room_id, false, message)
            {:error, %{reason: message}}
        end

      :error ->
        Logger.log_room_access(room_id, false, "Room is full")
        {:error, %{reason: "Room is full"}}
    end
  end

  @doc """
    Ping handle_in.

    Send info about the channel
  """
  @impl true
  def handle_in("ping", payload, socket) do
    with {:ok, room_id} <- GetInfo.get(payload) do
      {:reply, {:ok, room_id}, socket}
    end
  end

  @doc """
    Handles shouts from the client and broadcast to all.
  """
  @impl true
  def handle_in("shout", payload, socket) do
    case validate_message(payload) do
      :ok ->
        case check_rate_limit(socket) do
          :ok ->
            sanitized_message = sanitize_message(payload)
            broadcast(socket, "shout", sanitized_message)
            {:noreply, socket}

          :error ->
            {:reply, {:error, %{reason: "Rate limit exceeded"}}, socket}
        end

      :error ->
        {:reply, {:error, %{reason: "Invalid message"}}, socket}
    end
  end

  @doc """
    Handles new messages
  """
  def handle_in("new_message", %{"body" => body, "user" => user, "color" => color}, socket) do
    case validate_message(%{"body" => body}) do
      :ok ->
        case check_rate_limit(socket) do
          :ok ->
            sanitized_message = %{
              body: sanitize_message(body),
              user: sanitize_message(user),
              color: sanitize_message(color)
            }

            broadcast!(socket, "new_message", sanitized_message)
            {:noreply, socket}

          :error ->
            {:reply, {:error, %{reason: "Rate limit exceeded"}}, socket}
        end

      :error ->
        {:reply, {:error, %{reason: "Invalid message"}}, socket}
    end
  end

  defp check_connection_limit(room_id) do
    case Cachex.get(:room_connections, room_id) do
      {:ok, nil} ->
        Cachex.put(:room_connections, room_id, 1)
        :ok

      {:ok, count} when count < @max_connections_per_room ->
        Cachex.incr(:room_connections, room_id)
        :ok

      _ ->
        :error
    end
  end

  defp check_rate_limit(socket) do
    key = "rate_limit:#{socket.id}"

    case Cachex.get(:rate_limit_cache, key) do
      {:ok, nil} ->
        Cachex.put(:rate_limit_cache, key, 1, ttl: 60)
        :ok

      {:ok, count} when count < @max_messages_per_minute ->
        Cachex.incr(:rate_limit_cache, key)
        :ok

      _ ->
        :error
    end
  end

  defp validate_message(%{"body" => body}) when is_binary(body) do
    if String.length(body) <= @max_message_length do
      :ok
    else
      :error
    end
  end

  defp validate_message(_), do: :error

  defp sanitize_message(message) when is_binary(message) do
    message
    # Remove HTML tags
    |> String.replace(~r/<[^>]*>/, "")
    # Remove HTML entities
    |> String.replace(~r/&[^;]+;/, "")
    |> String.trim()
  end

  defp sanitize_message(message), do: message
end
