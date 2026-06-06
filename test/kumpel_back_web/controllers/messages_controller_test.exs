defmodule KumpelBackWeb.Messages.MessagesControllerTest do
  use KumpelBackWeb.ConnCase

  alias KumpelBack.TestFixtures

  describe "index/2 — message history" do
    test "returns empty list for room with no messages" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}/messages")
      body = json_response(conn, 200)

      assert body["data"] == []
      assert body["has_more"] == false
    end

    test "returns messages in chronological order" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      TestFixtures.insert_message!(room.id, %{body: "first"})
      TestFixtures.insert_message!(room.id, %{body: "second"})

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}/messages")
      body = json_response(conn, 200)
      bodies = Enum.map(body["data"], & &1["body"])

      assert bodies == ["first", "second"]
    end

    test "each message has required fields" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      TestFixtures.insert_message!(room.id, %{body: "hello", user_name: "Alice", color: "#FF5733"})

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}/messages")
      [msg] = json_response(conn, 200)["data"]

      assert is_binary(msg["id"])
      assert msg["body"] == "hello"
      assert msg["user"] == "Alice"
      assert msg["color"] == "#FF5733"
      assert is_binary(msg["inserted_at"])
    end

    test "paginates and returns has_more true" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      for i <- 1..5 do
        TestFixtures.insert_message!(room.id, %{body: "msg #{i}"})
      end

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}/messages?limit=3")
      body = json_response(conn, 200)

      assert length(body["data"]) == 3
      assert body["has_more"] == true
    end

    test "cursor-based pagination with before param" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      msg1 = TestFixtures.insert_message!(room.id, %{body: "old message"})
      msg2 = TestFixtures.insert_message!(room.id, %{body: "new message"})

      # Cursor equals msg2.inserted_at so only msg1 matches (strictly less than)
      cursor = DateTime.to_iso8601(msg2.inserted_at)

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}/messages?before=#{cursor}")
      body = json_response(conn, 200)
      ids = Enum.map(body["data"], & &1["id"])

      assert msg1.id in ids
      refute msg2.id in ids
    end

    test "returns 404 for unknown room" do
      conn = get(build_conn(), ~p"/api/rooms/#{Ecto.UUID.generate()}/messages")
      assert json_response(conn, 404)
    end

    test "returns 400 for invalid before cursor" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      conn = get(build_conn(), ~p"/api/rooms/#{room.id}/messages?before=not-a-date")
      assert json_response(conn, 400)
    end
  end
end
