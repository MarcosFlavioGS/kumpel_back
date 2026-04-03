defmodule KumpelBack.Users.PasswordTest do
  use ExUnit.Case, async: true

  alias KumpelBack.Users.Password

  describe "validate/1" do
    test "accepts a strong password" do
      assert :ok == Password.validate("Abcd1234!")
    end

    test "rejects short password" do
      assert {:error, _} = Password.validate("Ab1!")
    end

    test "rejects password without uppercase" do
      assert {:error, _} = Password.validate("abcd1234!")
    end

    test "rejects password without special character" do
      assert {:error, _} = Password.validate("Abcd1234")
    end

    test "rejects non-string" do
      assert {:error, _} = Password.validate(nil)
    end

    test "rejects password longer than 72 characters" do
      long = String.duplicate("Aa1!", 20)
      assert {:error, _} = Password.validate(long)
    end
  end
end
