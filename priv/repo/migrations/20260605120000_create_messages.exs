defmodule KumpelBack.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :body, :text, null: false
      add :user_name, :string, null: false
      add :color, :string
      add :room_id, references(:rooms, type: :uuid, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :uuid, on_delete: :nilify_all)

      timestamps(type: :utc_datetime_usec, updated_at: false)
    end

    create index(:messages, [:room_id, :inserted_at])
  end
end
