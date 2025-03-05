defmodule KumpelBack.Repo.Migrations.Rooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :code, :string
      add :adm_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:rooms, [:adm_id])
  end
end
