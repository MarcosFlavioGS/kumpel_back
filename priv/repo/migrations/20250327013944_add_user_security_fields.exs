defmodule KumpelBack.Repo.Migrations.AddUserSecurityFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :failed_login_attempts, :integer, default: 0, null: false
      add :locked_until, :utc_datetime, null: true
      add :last_login, :utc_datetime, null: true
    end

    create index(:users, [:locked_until])
    create index(:users, [:last_login])
  end
end
