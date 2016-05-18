defmodule Odisseu.PerfilCheckerTest do
  use Odisseu.ModelCase
  alias Odisseu.TestHelper
  alias Odisseu.PerfilChecker

  test "is_admin? is true when user has an admin perfil" do
    {:ok, perfil} = TestHelper.create_perfil(%{descricao: "Admin", admin: true})
    {:ok, sede} = TestHelper.create_sede(%{email: "some content", estado: "estado", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})
    {:ok, user} = TestHelper.create_user(perfil, sede, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    assert PerfilChecker.is_admin?(user)
  end

  test "is_admin? is false when user does not have an admin perfil" do
    {:ok, perfil} = TestHelper.create_perfil(%{descricao: "User", admin: false})
    {:ok, sede} = TestHelper.create_sede(%{email: "some content", estado: "estado", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})
    {:ok, user} = TestHelper.create_user(perfil, sede, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    refute PerfilChecker.is_admin?(user)
  end
end
