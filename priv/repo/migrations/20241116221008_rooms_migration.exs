defmodule KumpelBack.Repo.Migrations.RoomsMigration do
  use Ecto.Migration

  def change do
    create table("Rooms") do
      add :name, :string
      add :code_hash, :string
      add :adm, :string

      timestamps()
    end
  end
end
