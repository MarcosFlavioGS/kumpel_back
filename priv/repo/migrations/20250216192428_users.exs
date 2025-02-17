defmodule KumpelBack.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :mail, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end
  end
end
