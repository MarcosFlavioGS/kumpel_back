defmodule KumpelBack.Repo.Migrations.UniqueIndexRoomsCode do
  use Ecto.Migration

  @doc """
  Ensures access codes are unique so server-generated codes cannot silently collide.

  If this fails, resolve duplicate `rooms.code` values in the database before re-running.
  """
  def change do
    create unique_index(:rooms, [:code])
  end
end
