defmodule KumpelBack.RoomsTest do
  use KumpelBack.DataCase

  alias KumpelBack.Rooms
  alias KumpelBack.TestFixtures

  describe "create/2" do
    test "creates a room with server-assigned code" do
      user = TestFixtures.insert_user!()

      assert {:ok, room} = Rooms.create(%{"name" => "My Room"}, user.id)
      assert room.name == "My Room"
      assert room.adm_id == user.id
      assert is_binary(room.code)
      assert String.length(room.code) >= 8
    end

    test "returns changeset error for short name" do
      user = TestFixtures.insert_user!()

      assert {:error, %Ecto.Changeset{} = cs} =
               Rooms.create(%{"name" => "x"}, user.id)

      assert %{name: _} = errors_on(cs)
    end
  end

  describe "get/1" do
    test "returns room when id exists" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:ok, fetched} = Rooms.get(room.id)
      assert fetched.id == room.id
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()
      assert {:error, :not_found} = Rooms.get(fake)
    end
  end

  describe "list/0" do
    test "returns rooms when at least one exists" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:ok, rooms} = Rooms.list()
      assert Enum.any?(rooms, &(&1.id == room.id))
    end

    test "returns not_found when there are no rooms" do
      assert {:error, :not_found} = Rooms.list()
    end
  end

  describe "update/1" do
    test "updates an existing room" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:ok, updated} =
               Rooms.update(%{
                 "id" => room.id,
                 "name" => "Renamed Room",
                 "code" => room.code
               })

      assert updated.name == "Renamed Room"
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()

      assert {:error, :not_found} =
               Rooms.update(%{"id" => fake, "name" => "Does Not Exist"})
    end
  end

  describe "delete/1" do
    test "deletes an existing room" do
      user = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(user.id)

      assert {:ok, deleted} = Rooms.delete(room.id)
      assert deleted.id == room.id
      assert {:error, :not_found} = Rooms.get(room.id)
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()
      assert {:error, :not_found} = Rooms.delete(fake)
    end
  end
end
