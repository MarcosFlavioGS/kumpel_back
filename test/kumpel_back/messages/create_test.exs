defmodule KumpelBack.Messages.CreateTest do
  use KumpelBack.DataCase

  alias KumpelBack.Messages
  alias KumpelBack.TestFixtures

  describe "create/1" do
    test "inserts a message with valid params" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:ok, msg} =
               Messages.create(%{
                 body: "Hello world",
                 user_name: "Alice",
                 color: "#FF5733",
                 room_id: room.id
               })

      assert msg.body == "Hello world"
      assert msg.user_name == "Alice"
      assert msg.room_id == room.id
      assert msg.id != nil
    end

    test "returns changeset error when body is missing" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:error, %Ecto.Changeset{} = cs} =
               Messages.create(%{user_name: "Alice", room_id: room.id})

      assert %{body: _} = errors_on(cs)
    end

    test "returns changeset error when room_id is missing" do
      assert {:error, %Ecto.Changeset{} = cs} =
               Messages.create(%{body: "Hello", user_name: "Alice"})

      assert %{room_id: _} = errors_on(cs)
    end

    test "returns changeset error when body exceeds max length" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      long_body = String.duplicate("a", 1001)

      assert {:error, %Ecto.Changeset{} = cs} =
               Messages.create(%{body: long_body, user_name: "Alice", room_id: room.id})

      assert %{body: _} = errors_on(cs)
    end
  end
end
