defmodule KumpelBack.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :adm]}
  schema "Rooms" do
    field :name, :string
    field :code_hash
    field :adm, :string

    timestamps()
  end

  def changeset(room \\ %__MODULE__{}, params) do
    room
    |> cast(params, [:name, :code_hash, :adm])
    |> validate_length(:name, min: 4)
    |> validate_length(:code_hash, min: 4)
    |> validate_required([:name, :code_hash, :adm])
  end
end
