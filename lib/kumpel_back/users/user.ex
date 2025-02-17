defmodule KumpelBack.Users.User do
  @moduledoc """
  	Module that contains User schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:name, :mail, :password]
  @required_params_update [:name, :mail, :password]

  @derive {Jason.Encoder, only: [:name, :mail, :created_rooms, :subscribed_rooms]}
  schema "users" do
    field :name, :string
    field :mail, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :created_rooms, KumpelBack.Rooms.Room, foreign_key: :adm_id

    many_to_many :subscribed_rooms, KumpelBack.Rooms.Room, join_through: "subscriptions"

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> validate_required(@required_params_create)
    |> validate_format(:mail, ~r/@/)
    |> validate_length(:name, min: 2)
    |> validate_length(:password, min: 6)
    |> add_password_hash()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_params_create)
    |> validate_required(@required_params_update)
    |> validate_length(:name, min: 2)
  end

  defp add_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp add_password_hash(changeset), do: changeset
end
