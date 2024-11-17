defmodule KumpelBack.Repo.Migrations.RoomsMigration do
  use Ecto.Migration

  def change do
    create table("Rooms") do
      add :name, :string
      add :code, :string
      add :adm, :string

      timestamps()
    end
  end
end
