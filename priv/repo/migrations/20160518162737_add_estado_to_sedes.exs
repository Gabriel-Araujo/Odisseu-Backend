defmodule Odisseu.Repo.Migrations.AddEstadoToSedes do
  use Ecto.Migration

  def change do
    alter table(:sedes) do
      add :estado, :string
    end
  end
end
