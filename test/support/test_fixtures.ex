defmodule KumpelBack.TestFixtures do
  @moduledoc """
  Lightweight test data builders (no ExMachina in this project).
  """

  alias KumpelBack.Repo
  alias KumpelBack.Rooms.Room

  @valid_password "Abcd1234!"

  @doc """
  Password that satisfies `KumpelBack.Users.Password` rules.
  """
  def valid_password, do: @valid_password

  @doc """
  Default attrs for `Users.create/1`-style params.
  """
  def user_attrs(attrs \\ %{}) do
    n = System.unique_integer([:positive])

    Map.merge(
      %{
        "name" => "User #{n}",
        "mail" => "user#{n}@example.com",
        "password" => @valid_password
      },
      attrs
    )
  end

  @doc """
  Inserts a user via the Users context (hashing password, validations).
  """
  def insert_user!(attrs \\ %{}) do
    {:ok, user} = KumpelBack.Users.create(user_attrs(attrs))
    user
  end

  @doc """
  Inserts a room with generated `code` and `adm_id` (bypasses `Rooms.create` code generation).
  """
  def insert_room!(adm_id, _attrs \\ %{}) do
    n = System.unique_integer([:positive])

    code =
      :crypto.strong_rand_bytes(8)
      |> Base.encode32(padding: false)
      |> String.slice(0, 10)
      |> String.upcase()

    # Use struct insert: `Room.changeset/1` + string keys does not reliably cast `adm_id` here.
    %Room{name: "Room #{n}", code: code, adm_id: adm_id}
    |> Repo.insert!()
  end

  @doc """
  Adds `Authorization: Bearer …` for a user access token.
  """
  def put_auth(conn, user) do
    token = KumpelBackWeb.Token.sign(user)

    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end

  @doc """
  Inserts a chat message for a given room.

  After the regular insert (which uses Ecto autogenerate for `inserted_at`), immediately
  updates the timestamp to an explicit value derived from a monotonically increasing counter.
  This guarantees distinct, correctly ordered timestamps across multiple calls within the
  same test even when the wall clock doesn't advance.
  """
  def insert_message!(room_id, attrs \\ %{}) do
    import Ecto.Query, only: [from: 2]
    alias KumpelBack.Messages.Message

    n = System.unique_integer([:positive])
    # Monotonic integer as second offset from a fixed base — survives DB second-level truncation
    offset_s = System.unique_integer([:positive, :monotonic])
    inserted_at = Map.get(attrs, :inserted_at, DateTime.add(~U[2020-01-01 00:00:00Z], offset_s, :second))

    params = %{
      body: Map.get(attrs, :body, "Message #{n}"),
      user_name: Map.get(attrs, :user_name, "TestUser"),
      color: Map.get(attrs, :color, "#FF5733"),
      room_id: room_id
    }

    {:ok, msg} = KumpelBack.Messages.create(params)

    Repo.update_all(
      from(m in Message, where: m.id == ^msg.id),
      set: [inserted_at: inserted_at]
    )

    Repo.get!(Message, msg.id)
  end

  @doc """
  Encodes params as JSON request body.
  """
  def json_body(params) do
    Jason.encode!(params)
  end
end
