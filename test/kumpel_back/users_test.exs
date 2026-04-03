defmodule KumpelBack.UsersTest do
  use KumpelBack.DataCase

  alias KumpelBack.Users
  alias KumpelBack.TestFixtures

  describe "create/1" do
    test "creates a user with valid params" do
      attrs = TestFixtures.user_attrs()

      assert {:ok, user} = Users.create(attrs)
      assert user.name == attrs["name"]
      assert user.mail == attrs["mail"]
      assert user.password_hash
    end

    test "returns changeset error for invalid email" do
      attrs = TestFixtures.user_attrs(%{"mail" => "not-an-email"})

      assert {:error, %Ecto.Changeset{} = cs} = Users.create(attrs)
      assert %{mail: _} = errors_on(cs)
    end

    test "returns changeset error for weak password" do
      attrs = TestFixtures.user_attrs(%{"password" => "short"})

      assert {:error, %Ecto.Changeset{} = cs} = Users.create(attrs)
      assert %{password: _} = errors_on(cs)
    end

    test "returns changeset error for duplicate mail" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, _} = Users.create(attrs)

      assert {:error, %Ecto.Changeset{} = cs} = Users.create(attrs)
      assert %{mail: _} = errors_on(cs)
    end
  end

  describe "login/1" do
    test "returns user for valid credentials" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, created} = Users.create(attrs)

      assert {:ok, user} =
               Users.login(%{"mail" => attrs["mail"], "password" => attrs["password"]})

      assert user.id == created.id
    end

    test "returns not_found for unknown mail" do
      assert {:error, :not_found} =
               Users.login(%{
                 "mail" => "missing@example.com",
                 "password" => TestFixtures.valid_password()
               })
    end

    test "returns unauthorized for wrong password" do
      attrs = TestFixtures.user_attrs()
      assert {:ok, _} = Users.create(attrs)

      assert {:error, :unauthorized} =
               Users.login(%{"mail" => attrs["mail"], "password" => "WrongPass1!"})
    end
  end

  describe "get/1" do
    test "returns user when id exists" do
      user = TestFixtures.insert_user!()
      assert {:ok, fetched} = Users.get(user.id)
      assert fetched.id == user.id
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()
      assert {:error, :not_found} = Users.get(fake)
    end
  end

  describe "list/0" do
    test "returns users when at least one exists" do
      user = TestFixtures.insert_user!()
      assert {:ok, users} = Users.list()
      assert Enum.any?(users, &(&1.id == user.id))
    end

    test "returns not_found when there are no users" do
      assert {:error, :not_found} = Users.list()
    end
  end

  describe "update/1" do
    test "updates an existing user" do
      user = TestFixtures.insert_user!()

      assert {:ok, updated} =
               Users.update(%{
                 "id" => user.id,
                 "name" => "Updated Name",
                 "mail" => user.mail
               })

      assert updated.name == "Updated Name"
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()

      assert {:error, :not_found} =
               Users.update(%{
                 "id" => fake,
                 "name" => "N",
                 "mail" => "x@y.com"
               })
    end
  end

  describe "delete/1" do
    test "deletes an existing user" do
      user = TestFixtures.insert_user!()
      assert {:ok, deleted} = Users.delete(user.id)
      assert deleted.id == user.id
      assert {:error, :not_found} = Users.get(user.id)
    end

    test "returns not_found for unknown id" do
      fake = Ecto.UUID.generate()
      assert {:error, :not_found} = Users.delete(fake)
    end
  end
end
