defmodule Odisseu.EventoTest do
  use Odisseu.ModelCase

  alias Odisseu.Evento

  @valid_attrs %{ativo: true, data_extenso: "some content", descricao: "some content", extra: "some content", final: "2010-04-17 14:00:00", inicio: "2010-04-17 14:00:00", localizacao_gps: "some content", resumo: "some content", subtitulo: "some content", titulo: "some content", url_imagem: "some content", url_inscricao: "some content", url_maps: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Evento.changeset(%Evento{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Evento.changeset(%Evento{}, @invalid_attrs)
    refute changeset.valid?
  end
end
