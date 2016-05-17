defmodule Odisseu.Repo.Migrations.AddUlissesIdToEventos do
  use Ecto.Migration

  def change do
    alter table(:eventos) do
      add :ulisses_id, :integer, null: true
    end
  end
end
