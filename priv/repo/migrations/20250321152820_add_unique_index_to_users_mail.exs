defmodule KumpelBack.Repo.Migrations.AddUniqueIndexToUsersMail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:mail])
  end
end
