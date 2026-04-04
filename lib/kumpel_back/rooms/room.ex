defmodule KumpelBack.Rooms.Room do
  @moduledoc """
  	Module that contains Room schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @cast_create [:name, :adm_id, :code, :image_url]

  @derive {Jason.Encoder, only: [:id, :name, :adm_id, :code, :subscribers, :image_url]}
  schema "rooms" do
    field :name, :string
    field :code, :string
    field :image_url, :string

    belongs_to :adm, KumpelBack.Users.User, foreign_key: :adm_id

    many_to_many :subscribers, KumpelBack.Users.User, join_through: "subscriptions"

    timestamps()
  end

  @type t :: %__MODULE__{}

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @cast_create)
    |> validate_required([:name, :adm_id, :code])
    |> validate_length(:name, min: 2)
    |> validate_length(:code, min: 8, max: 32)
    |> foreign_key_constraint(:adm_id)
    |> unique_constraint(:code)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(room, params) do
    room
    |> cast(params, [:name, :code, :image_url])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> validate_length(:code, min: 6, max: 32)
    |> unique_constraint(:code)
  end
end
