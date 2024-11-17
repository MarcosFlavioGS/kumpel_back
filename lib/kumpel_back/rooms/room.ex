defmodule KumpelBack.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:name, :code, :adm]
  @required_params_update [:name, :code, :adm]

  @derive {Jason.Encoder, only: [:name, :adm, :code]}
  schema "Rooms" do
    field :name, :string
    field :code, :string
    field :adm, :string

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
