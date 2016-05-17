defmodule Odisseu.Repo.Migrations.CreateEvento do
  use Ecto.Migration

  def change do
    create table(:eventos) do
      add :titulo, :string
      add :subtitulo, :string
      add :resumo, :text
      add :descricao, :text
      add :extra, :text
      add :url_imagem, :string
      add :data_extenso, :string
      add :inicio, :datetime
      add :final, :datetime
      add :url_maps, :string
      add :url_inscricao, :string
      add :localizacao_gps, :string
      add :ativo, :boolean, default: false
      add :categoria_id, references(:categorias, on_delete: :nothing)
      add :sede_id, references(:sedes, on_delete: :nothing)

      timestamps
    end
    create index(:eventos, [:categoria_id])
    create index(:eventos, [:sede_id])

  end
end
