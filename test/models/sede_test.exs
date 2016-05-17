defmodule Odisseu.SedeTest do
  use Odisseu.ModelCase

  alias Odisseu.Sede

  @valid_attrs %{email: "some content", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Sede.changeset(%Sede{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Sede.changeset(%Sede{}, @invalid_attrs)
    refute changeset.valid?
  end
end
