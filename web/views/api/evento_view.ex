defmodule Odisseu.Api.EventoView do
  use Odisseu.Web, :view

  def render("index.json", %{eventos: eventos}) do
    %{data: render_many(eventos, Odisseu.Api.EventoView, "evento.json")}
  end

  def render("show.json", %{evento: evento}) do
    %{data: render_one(evento, Odisseu.Api.EventoView, "evento.json")}
  end

  def render("evento.json", %{evento: evento}) do
    %{
      id: evento.id,
      titulo: evento.titulo,
      subtitulo: evento.subtitulo,
      resumo: evento.resumo,
      descricao: evento.descricao,
      extra: evento.extra,
      url_imagem: evento.url_imagem,
      data_extenso: evento.data_extenso,
      inicio: evento.inicio,
      final: evento.final,
      url_maps: evento.url_maps,
      url_inscricao: evento.url_inscricao,
      localizacao_gps: evento.localizacao_gps,
      ativo: evento.ativo,
      ulisses_id: evento.ulisses_id
    }
  end
end
