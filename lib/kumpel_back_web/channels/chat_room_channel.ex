defmodule KumpelBackWeb.ChatRoomChannel do
  @moduledoc """
    This is the module responsable for the chat_room:* channel.
  """

  use KumpelBackWeb, :channel
  alias KumpelBack.Rooms.Authorize
  alias KumpelBack.Rooms.GetInfo

  @doc """
    This is the join function to the main room called lobby. It is free for all and does not need authentication.
  """
  @impl true
  def join("chat_room:lobby", _payload, socket) do
    case Authorize.authorized("lobby") do
      {:ok, _message} -> {:ok, socket}
      {:error, message} -> {:error, %{reason: message}}
    end
  end

  @doc """
    This endpoint checks for an existing room on the DB and return the socket if the provided code is valid.
  """
  @impl true
  def join("chat_room:" <> room_id, payload, socket) do
    case Authorize.authorized(room_id, payload) do
      {:ok, _message} ->
        {:ok, socket}

      {:error, message} ->
        IO.puts(message)
        {:error, %{reason: message}}
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
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @doc """
    Handles new messages
  """
  def handle_in("new_message", %{"body" => body, "user" => user, "color" => color}, socket) do
    broadcast!(socket, "new_message", %{body: body, user: user, color: color})
    {:noreply, socket}
  end
end
