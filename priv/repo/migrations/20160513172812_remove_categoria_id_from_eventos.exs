defmodule Odisseu.Repo.Migrations.RemoveCategoriaIdFromEventos do
  use Ecto.Migration

  def change do
    alter table(:eventos) do
      remove :categoria_id
    end
    drop_if_exists index(:eventos, [:categoria_id])
    drop_if_exists table(:categorias)
  end
end
