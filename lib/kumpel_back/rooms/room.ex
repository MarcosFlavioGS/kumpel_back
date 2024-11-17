defmodule KumpelBack.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:name, :code, :adm]
  @required_params_update [:name, :adm]

  @derive {Jason.Encoder, only: [:name, :adm]}
  schema "Rooms" do
    field :name, :string
    field :code, :string, virtual: true
    field :code_hash
    field :adm, :string

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> validate_required(@required_params_create)
    |> validate_length(:name, min: 2)
    |> validate_length(:code, min: 6)
    |> add_code_hash()
  end

  def changeset(room, params) do
    room
    |> cast(params, @required_params_create)
    |> validate_required(@required_params_update)
    |> validate_length(:name, min: 2)
    |> validate_length(:code, min: 6)
    |> add_code_hash()
  end

  defp add_code_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp add_code_hash(changeset), do: changeset
end
