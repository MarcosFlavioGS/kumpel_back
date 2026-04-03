defmodule KumpelBackWeb.TokenTest do
  use KumpelBack.DataCase

  alias KumpelBackWeb.Token
  alias KumpelBack.TestFixtures

  describe "sign/1 and verify/1" do
    test "round-trips access token payload" do
      user = TestFixtures.insert_user!()
      token = Token.sign(user)

      assert {:ok, data} = Token.verify(token)
      assert data.user_id == user.id
      assert data.user_mail == user.mail
      assert is_integer(data.exp)
    end

    test "rejects malformed token" do
      assert {:error, _} = Token.verify("not-a-valid-token")
    end
  end

  describe "sign_refresh/1 and verify_refresh/1" do
    test "round-trips refresh token" do
      user = TestFixtures.insert_user!()
      token = Token.sign_refresh(user)

      assert {:ok, data} = Token.verify_refresh(token)
      assert data.user_id == user.id
    end
  end
end
