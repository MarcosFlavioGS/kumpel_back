defmodule KumpelBack.Messages.Message do
  @moduledoc """
  Schema for a persisted chat message.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime_usec]

  @cast_fields [:body, :user_name, :color, :room_id, :user_id]

  schema "messages" do
    field :body, :string
    field :user_name, :string
    field :color, :string

    belongs_to :room, KumpelBack.Rooms.Room
    belongs_to :user, KumpelBack.Users.User

    timestamps(updated_at: false)
  end

  @type t :: %__MODULE__{}

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required([:body, :user_name, :room_id])
    |> validate_length(:body, min: 1, max: 1000)
    |> foreign_key_constraint(:room_id)
    |> foreign_key_constraint(:user_id)
  end
end
