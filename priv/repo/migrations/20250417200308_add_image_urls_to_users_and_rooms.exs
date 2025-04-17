defmodule KumpelBack.Repo.Migrations.AddImageUrlsToUsersAndRooms do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image_url, :string, null: true
    end

    alter table(:rooms) do
      add :image_url, :string, null: true
    end
  end
end
