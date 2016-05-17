defmodule Odisseu.Evento do
  use Odisseu.Web, :model

  schema "eventos" do
    field :titulo, :string
    field :subtitulo, :string
    field :resumo, :string
    field :descricao, :string
    field :extra, :string
    field :url_imagem, :string
    field :data_extenso, :string
    field :inicio, Ecto.DateTime
    field :final, Ecto.DateTime
    field :url_maps, :string
    field :url_inscricao, :string
    field :localizacao_gps, :string
    field :ativo, :boolean, default: true
    field :ulisses_id, :integer, null: true
    belongs_to :sede, Odisseu.Sede

    timestamps
  end

  @required_fields ~w(titulo subtitulo resumo descricao extra url_imagem data_extenso inicio final url_maps url_inscricao localizacao_gps ativo)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
