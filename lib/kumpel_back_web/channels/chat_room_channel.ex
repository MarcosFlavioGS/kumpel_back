defmodule KumpelBackWeb.ChatRoomChannel do
  @moduledoc """
    This is the module responsable for the chat_room:* channel.
  """

  use KumpelBackWeb, :channel
  alias KumpelBack.Rooms.Authorize

  @doc """
    This is the join function to the main room called lobby. It is free for all and does not need authentication.
  """
  @impl true
  def join("chat_room:lobby", payload, socket) do
    with {:ok, _message} <- Authorize.authorized("lobby") do
      {:ok, socket}
    else
      {:error, message} -> {:error, %{reason: message}}
    end
  end

  @doc """
    This endpoint checks for an existing room on the DB and return the socket if the provided code is valid.
  """
  @impl true
  def join("chat_room:" <> room_id, payload, socket) do
    with {:ok, _message} <- Authorize.authorized(room_id, payload) do
      {:ok, socket}
    else
      {:error, message} ->
        IO.puts(message)
        {:error, %{reason: message}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("new_message", %{"body" => body, "user" => user}, socket) do
    broadcast!(socket, "new_message", %{body: body, user: user})
    {:noreply, socket}
  end
end
