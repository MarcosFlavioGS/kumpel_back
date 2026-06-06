defmodule KumpelBack.Messages.ListByRoomTest do
  use KumpelBack.DataCase

  alias KumpelBack.Messages
  alias KumpelBack.TestFixtures

  describe "list_by_room/2" do
    test "returns empty list for room with no messages" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:ok, [], false} = Messages.list_by_room(room.id)
    end

    test "returns messages in chronological order" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      msg1 = TestFixtures.insert_message!(room.id, %{body: "first"})
      msg2 = TestFixtures.insert_message!(room.id, %{body: "second"})
      msg3 = TestFixtures.insert_message!(room.id, %{body: "third"})

      assert {:ok, messages, false} = Messages.list_by_room(room.id)
      ids = Enum.map(messages, & &1.id)
      assert ids == [msg1.id, msg2.id, msg3.id]
    end

    test "paginates with limit and has_more flag" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      for i <- 1..5 do
        TestFixtures.insert_message!(room.id, %{body: "msg #{i}"})
      end

      assert {:ok, messages, true} = Messages.list_by_room(room.id, limit: 3)
      assert length(messages) == 3
    end

    test "has_more is false when messages fit within limit" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      for i <- 1..3 do
        TestFixtures.insert_message!(room.id, %{body: "msg #{i}"})
      end

      assert {:ok, messages, false} = Messages.list_by_room(room.id, limit: 10)
      assert length(messages) == 3
    end

    test "before cursor filters older messages" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      msg1 = TestFixtures.insert_message!(room.id, %{body: "old"})
      msg2 = TestFixtures.insert_message!(room.id, %{body: "new"})

      # Cursor is exactly msg2.inserted_at so only msg1 should match (strictly less than)
      cursor = msg2.inserted_at

      assert {:ok, messages, false} = Messages.list_by_room(room.id, before: cursor)
      ids = Enum.map(messages, & &1.id)
      assert msg1.id in ids
      refute msg2.id in ids
    end

    test "does not return messages from other rooms" do
      user = TestFixtures.insert_user!()
      room_a = TestFixtures.insert_room!(user.id)
      room_b = TestFixtures.insert_room!(user.id)

      TestFixtures.insert_message!(room_b.id)

      assert {:ok, [], false} = Messages.list_by_room(room_a.id)
    end
  end
end
