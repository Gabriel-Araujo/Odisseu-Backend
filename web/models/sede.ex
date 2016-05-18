defmodule Odisseu.Sede do
  use Odisseu.Web, :model

  schema "sedes" do
    field :nome, :string
    field :estado, :string
    field :endereco, :string
    field :telefone, :string
    field :email, :string
    field :url_imagem, :string
    field :url_instagram, :string
    field :url_facebook, :string
    field :url_maps, :string
    field :url_ulisses, :string
    field :localizacao_gps, :string
    has_many :eventos, Odisseu.Evento
    has_many :users, Odisseu.User

    timestamps
  end

  @required_fields ~w(nome estado endereco telefone email url_imagem url_instagram url_facebook url_maps url_ulisses localizacao_gps)
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
