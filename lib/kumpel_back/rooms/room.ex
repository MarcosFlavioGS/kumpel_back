defmodule KumpelBack.Rooms.Room do
  @moduledoc """
  	Module that contains Room schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:name, :code]
  @required_params_update [:name, :code]

  @derive {Jason.Encoder, only: [:name, :adm, :code, :subscribers]}
  schema "rooms" do
    field :name, :string
    field :code, :string

    belongs_to :adm, KumpelBack.Users.User, foreign_key: :adm_id

    many_to_many :subscribers, MyApp.Users.User, join_through: "subscriptions"

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> validate_required(@required_params_create)
    |> validate_length(:name, min: 2)
    |> validate_length(:code, min: 6)
  end

  def changeset(room, params) do
    room
    |> cast(params, @required_params_create)
    |> validate_required(@required_params_update)
    |> validate_length(:name, min: 2)
    |> validate_length(:code, min: 6)
  end
end
