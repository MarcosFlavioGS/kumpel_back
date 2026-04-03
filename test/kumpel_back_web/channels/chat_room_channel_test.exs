defmodule KumpelBackWeb.ChatRoomChannelTest do
  use KumpelBackWeb.ChannelCase

  alias KumpelBack.TestFixtures
  alias KumpelBackWeb.ChatRoomChannel
  alias KumpelBackWeb.UserSocket

  setup do
    Cachex.clear(:room_connections)
    Cachex.clear(:rate_limit_cache)
    :ok
  end

  describe "join/3" do
    test "allows joining lobby when under connection limit" do
      assert {:ok, _, socket} =
               UserSocket
               |> socket("user_id", %{user_id: "test"})
               |> subscribe_and_join(ChatRoomChannel, "chat_room:lobby")

      assert socket
    end

    test "joins a real room when code matches" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:ok, _, _socket} =
               UserSocket
               |> socket("user_id", %{user_id: adm.id})
               |> subscribe_and_join(
                 ChatRoomChannel,
                 "chat_room:#{room.id}",
                 %{"code" => room.code}
               )
    end

    test "rejects join when room code is wrong" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:error, %{reason: "Invalid code"}} =
               UserSocket
               |> socket("user_id", %{user_id: adm.id})
               |> subscribe_and_join(
                 ChatRoomChannel,
                 "chat_room:#{room.id}",
                 %{"code" => "NOTVALID1"}
               )
    end
  end

  describe "handle_in ping" do
    setup do
      {:ok, _, socket} =
        UserSocket
        |> socket("user_id", %{user_id: "test"})
        |> subscribe_and_join(ChatRoomChannel, "chat_room:lobby")

      %{socket: socket}
    end

    test "replies with lobby info for id lobby", %{socket: socket} do
      ref = push(socket, "ping", %{"id" => "lobby"})
      assert_reply ref, :ok, %KumpelBack.Rooms.Room{name: "Lobby"}
    end
  end

  describe "handle_in shout" do
    setup do
      {:ok, _, socket} =
        UserSocket
        |> socket("user_id", %{user_id: "test"})
        |> subscribe_and_join(ChatRoomChannel, "chat_room:lobby")

      %{socket: socket}
    end

    test "broadcasts valid shout payload", %{socket: socket} do
      push(socket, "shout", %{"body" => "hello everyone"})
      assert_broadcast "shout", %{"body" => "hello everyone"}
    end

    test "rejects shout without body", %{socket: socket} do
      ref = push(socket, "shout", %{"hello" => "all"})
      assert_reply ref, :error, %{reason: "Invalid message"}
    end

    test "strips HTML from body", %{socket: socket} do
      push(socket, "shout", %{"body" => "hi<b>x</b>"})
      assert_broadcast "shout", %{"body" => "hix"}
    end
  end

  describe "handle_in new_message" do
    setup do
      {:ok, _, socket} =
        UserSocket
        |> socket("user_id", %{user_id: "test"})
        |> subscribe_and_join(ChatRoomChannel, "chat_room:lobby")

      %{socket: socket}
    end

    test "broadcasts sanitized chat message", %{socket: socket} do
      push(socket, "new_message", %{
        "body" => "hello",
        "user" => "alice",
        "color" => "#112233"
      })

      assert_broadcast "new_message", %{
        body: "hello",
        user: "alice",
        color: "#112233"
      }
    end
  end
end
