defmodule Odisseu.Factory do
  use ExMachina.Ecto, repo: Odisseu.Repo

  alias Odisseu.Perfil
  alias Odisseu.Sede
  alias Odisseu.User
  alias Odisseu.Evento

  def factory(:perfil) do
    %Perfil{
      descricao: sequence(:descricao, fn x -> "Test Perfil #{x}" end),
      admin: false
    }
  end

  def factory(:sede) do
    %Sede{
      nome: sequence(:nome, fn x -> "Test Sede #{x}" end),
      email: "some content",
      estado: "estado",
      endereco: "some content",
      localizacao_gps: "some content",
      telefone: "some content",
      url_facebook: "some content",
      url_imagem: "some content",
      url_instagram: "some content",
      url_maps: "some content",
      url_ulisses: "some content",
    }
  end

  def factory(:user) do
    %User{
      username: sequence(:username, &"Test User #{&1}"),
      email: "test@test.com",
      password: "test1234",
      password_confirmation: "test1234",
      hashed_password: Comeonin.Bcrypt.hashpwsalt("test1234"),
      perfil: build(:perfil),
      sede: build(:sede),
    }
  end

  def factory(:evento) do
    %Evento{
      titulo: sequence(:nome, fn x -> "Test Evento #{x}" end),
      ativo: true,
      data_extenso: "some content",
      descricao: "some content",
      extra: "some content",
      final: Ecto.DateTime.utc(), #cast("2010-04-17 14:00:00"),
      inicio: Ecto.DateTime.utc(), #cast("2010-04-17 14:00:00"),
      localizacao_gps: "some content",
      resumo: "some content",
      subtitulo: "some content",
      url_imagem: "some content",
      url_inscricao: "some content",
      url_maps: "some content",
      sede: build(:sede)
    }
  end
end
