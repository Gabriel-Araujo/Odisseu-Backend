defmodule Odisseu.Repo.Migrations.CreateSede do
  use Ecto.Migration

  def change do
    create table(:sedes) do
      add :nome, :string
      add :endereco, :string
      add :telefone, :string
      add :email, :string
      add :url_imagem, :string
      add :url_instagram, :string
      add :url_facebook, :string
      add :url_maps, :string
      add :url_ulisses, :string
      add :localizacao_gps, :string

      timestamps
    end

  end
end
