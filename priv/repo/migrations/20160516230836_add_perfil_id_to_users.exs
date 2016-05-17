defmodule Odisseu.Repo.Migrations.AddPerfilIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :perfil_id, references(:perfils)
    end
    create index(:users, [:perfil_id])
  end
end
