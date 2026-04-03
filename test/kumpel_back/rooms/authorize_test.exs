defmodule KumpelBack.Rooms.AuthorizeTest do
  use KumpelBack.DataCase

  alias KumpelBack.Rooms.Authorize
  alias KumpelBack.TestFixtures

  describe "authorized/1" do
    test "allows lobby" do
      assert {:ok, _} = Authorize.authorized("lobby")
    end
  end

  describe "authorized/2" do
    test "allows room when code matches" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:ok, _} = Authorize.authorized(room.id, %{"code" => room.code})
    end

    test "rejects when code does not match" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:error, "Invalid code"} =
               Authorize.authorized(room.id, %{"code" => "WRONGCODE"})
    end

    test "rejects when code key is missing" do
      adm = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:error, "Invalid or empty code"} = Authorize.authorized(room.id, %{})
    end

    test "rejects when room does not exist" do
      fake = Ecto.UUID.generate()

      assert {:error, "Room not found"} =
               Authorize.authorized(fake, %{"code" => "ANYCODE123"})
    end
  end
end
