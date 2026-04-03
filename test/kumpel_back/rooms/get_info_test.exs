defmodule KumpelBack.Rooms.GetInfoTest do
  use KumpelBack.DataCase

  alias KumpelBack.Rooms.GetInfo
  alias KumpelBack.TestFixtures

  describe "get/1" do
    test "returns lobby stub for id lobby" do
      assert {:ok, %KumpelBack.Rooms.Room{name: "Lobby"}} = GetInfo.get(%{"id" => "lobby"})
    end

    test "returns room name for existing id" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:ok, name} = GetInfo.get(%{"id" => room.id})
      assert name == room.name
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()
      assert {:error, "Room not found"} = GetInfo.get(%{"id" => fake})
    end
  end
end
