defmodule KumpelBack.Repo.Migrations.ConvertIdsToUuid do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    drop_if_exists table(:subscriptions)
    drop_if_exists table(:rooms)
    drop_if_exists table(:users)

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :mail, :string, null: false
      add :password_hash, :string, null: false
      add :failed_login_attempts, :integer, default: 0
      add :locked_until, :utc_datetime
      add :last_login, :utc_datetime
      add :image_url, :string

      timestamps()
    end

    create unique_index(:users, [:mail])

    create table(:rooms, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string
      add :code, :string
      add :adm_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      add :image_url, :string

      timestamps()
    end

    create index(:rooms, [:adm_id])

    create table(:subscriptions, primary_key: false) do
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      add :room_id, references(:rooms, type: :uuid, on_delete: :delete_all)
    end

    create unique_index(:subscriptions, [:user_id, :room_id])
  end

  def down do
    drop_if_exists table(:subscriptions)
    drop_if_exists table(:rooms)
    drop_if_exists table(:users)

    execute "DROP EXTENSION IF EXISTS \"uuid-ossp\""
  end
end
