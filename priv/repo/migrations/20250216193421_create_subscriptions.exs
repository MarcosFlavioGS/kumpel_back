defmodule KumpelBack.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :room_id, references(:rooms, on_delete: :delete_all)
    end

    create unique_index(:subscriptions, [:user_id, :room_id])

  end
end
