defmodule Odisseu.TestHelper do
  alias Odisseu.Repo
  alias Odisseu.User
  alias Odisseu.Perfil
  alias Odisseu.Sede
  alias Odisseu.Evento
  import Ecto, only: [build_assoc: 2]

  def create_perfil(%{descricao: descricao, admin: admin}) do
    Perfil.changeset(%Perfil{}, %{descricao: descricao, admin: admin})
    |> Repo.insert
  end

  def create_sede(%{email: email, endereco: endereco, localizacao_gps: localizacao_gps, nome: nome, telefone: telefone, url_facebook: url_facebook, url_imagem: url_imagem, url_instagram: url_instagram, url_maps: url_maps, url_ulisses: url_ulisses}) do
    Sede.changeset(%Sede{}, %{email: email, endereco: endereco, localizacao_gps: localizacao_gps, nome: nome, telefone: telefone, url_facebook: url_facebook, url_imagem: url_imagem, url_instagram: url_instagram, url_maps: url_maps, url_ulisses: url_ulisses})
    |> Repo.insert
  end

  def create_user(perfil, sede, %{email: email, username: username, password: password, password_confirmation: password_confirmation}) do
    perfil
    |> build_assoc(:users)
    |> Map.put(:sede_id, sede.id)
    |> User.changeset(%{email: email, username: username, password: password, password_confirmation: password_confirmation})
    |> Repo.insert
  end

  def create_evento(sede, %{ativo: ativo, data_extenso: data_extenso, descricao: descricao, extra: extra, final: final, inicio: inicio, localizacao_gps: localizacao_gps, resumo: resumo, subtitulo: subtitulo, titulo: titulo, url_imagem: url_imagem, url_inscricao: url_inscricao, url_maps: url_maps}) do
    sede
    |> build_assoc(:eventos)
    |> Evento.changeset(%{ativo: ativo, data_extenso: data_extenso, descricao: descricao, extra: extra, final: final, inicio: inicio, localizacao_gps: localizacao_gps, resumo: resumo, subtitulo: subtitulo, titulo: titulo, url_imagem: url_imagem, url_inscricao: url_inscricao, url_maps: url_maps})
    |> Repo.insert
  end
end
