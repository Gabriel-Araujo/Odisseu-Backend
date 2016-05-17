defmodule Odisseu.Repo.Migrations.CreateCategoria do
  use Ecto.Migration

  def change do
    create table(:categorias) do
      add :descricao, :string
      add :ativo, :boolean, default: false

      timestamps
    end

  end
end
