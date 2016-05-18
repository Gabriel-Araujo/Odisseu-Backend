defmodule Odisseu.Api.SedeView do
  use Odisseu.Web, :view

  def render("index.json", %{sedes: sedes}) do
    %{data: render_many(sedes, Odisseu.Api.SedeView, "sede.json")}
  end

  def render("show.json", %{sede: sede}) do
    %{data: render_one(sede, Odisseu.Api.SedeView, "sede.json")}
  end

  def render("sede.json", %{sede: sede}) do
    %{
      id: sede.id,
      nome: sede.nome,
      estado: sede.estado,
      endereco: sede.endereco,
      telefone: sede.telefone,
      email: sede.email,
      url_imagem: sede.url_imagem,
      url_instagram: sede.url_instagram,
      url_facebook: sede.url_facebook,
      url_maps: sede.url_maps,
      url_ulisses: sede.url_ulisses,
      localizacao_gps: sede.localizacao_gps
    }
  end
end
