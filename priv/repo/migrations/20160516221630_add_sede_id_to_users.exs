defmodule Odisseu.Repo.Migrations.AddSedeIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :sede_id, references(:sedes), null: true
    end
    create index(:users, [:sede_id])
  end
end
