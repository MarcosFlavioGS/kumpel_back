defmodule KumpelBack.SubscriptionTest do
  use KumpelBack.DataCase

  alias KumpelBack.Subscription
  alias KumpelBack.TestFixtures

  defp token_assigns(user) do
    %{user_id: user.id, user_mail: user.mail}
  end

  describe "subscribe/2" do
    test "subscribes user to room matching code and name" do
      adm = TestFixtures.insert_user!()
      joiner = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      assert {:ok, msg} =
               Subscription.subscribe(
                 token_assigns(joiner),
                 %{"code" => room.code, "name" => room.name}
               )

      assert msg == "Successfully subscribed to room"

      {:ok, reloaded} = KumpelBack.Users.get(joiner.id)
      assert Enum.any?(reloaded.subscribed_rooms, &(&1.id == room.id))
    end

    test "returns error when room code and name do not match" do
      user = TestFixtures.insert_user!()

      assert {:error, "Room not found with given code and name"} =
               Subscription.subscribe(
                 token_assigns(user),
                 %{"code" => "NOPECODE1", "name" => "Missing Room"}
               )
    end

    test "returns error when user is already subscribed" do
      adm = TestFixtures.insert_user!()
      joiner = TestFixtures.insert_user!()
      room = TestFixtures.insert_room!(adm.id)

      params = %{"code" => room.code, "name" => room.name}
      assert {:ok, _} = Subscription.subscribe(token_assigns(joiner), params)

      assert {:error, "User is already subscribed to this room"} =
               Subscription.subscribe(token_assigns(joiner), params)
    end

    test "returns error when user id in token does not exist" do
      fake_id = Ecto.UUID.generate()

      assert {:error, "User not found"} =
               Subscription.subscribe(
                 %{user_id: fake_id, user_mail: "ghost@example.com"},
                 %{"code" => "X", "name" => "Y"}
               )
    end
  end
end
