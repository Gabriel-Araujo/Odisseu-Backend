defmodule Odisseu.Repo.Migrations.CreatePerfil do
  use Ecto.Migration

  def change do
    create table(:perfils) do
      add :descricao, :string
      add :admin, :boolean, default: false

      timestamps
    end

  end
end
