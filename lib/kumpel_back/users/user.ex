defmodule KumpelBack.Users.User do
  @moduledoc """
  	Module that contains User schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias KumpelBack.Users.Password

  @required_params_create [:name, :mail, :password]
  @required_params_update [:name, :mail]

  @derive {Jason.Encoder, only: [:name, :mail, :created_rooms, :subscribed_rooms, :image_url]}
  schema "users" do
    field :name, :string
    field :mail, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :failed_login_attempts, :integer, default: 0
    field :locked_until, :utc_datetime
    field :last_login, :utc_datetime
    field :image_url, :string

    has_many :created_rooms, KumpelBack.Rooms.Room, foreign_key: :adm_id

    many_to_many :subscribed_rooms, KumpelBack.Rooms.Room, join_through: "subscriptions"

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create ++ [:image_url])
    |> validate_required(@required_params_create)
    |> validate_format(:mail, ~r/@/)
    |> validate_length(:name, min: 2)
    |> validate_password()
    |> unique_constraint(:mail)
    |> put_password_hash()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_params_update ++ [:image_url])
    |> validate_required(@required_params_update)
    |> validate_length(:name, min: 2)
    |> unique_constraint(:mail)
  end

  defp validate_password(changeset) do
    case get_change(changeset, :password) do
      nil ->
        add_error(changeset, :password, "Password is required")

      password ->
        case Password.validate(password) do
          :ok -> changeset
          {:error, reason} -> add_error(changeset, :password, reason)
        end
    end
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      password ->
        changeset
        |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
        |> delete_change(:password)
    end
  end
end
