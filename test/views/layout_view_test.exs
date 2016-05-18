defmodule Odisseu.LayoutViewTest do
  use Odisseu.ConnCase
  alias Odisseu.LayoutView
  alias Odisseu.TestHelper

  setup do
    {:ok, perfil} = TestHelper.create_perfil(%{descricao: "User", admin: false})
    {:ok, sede} = TestHelper.create_sede(%{email: "some content", estado: "estado", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})
    {:ok, user} = TestHelper.create_user(perfil, sede, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    conn = conn()
    {:ok, conn: conn, user: user}
  end

  test "current user returns the user in the session", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session", %{user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end

  test "deletes the user session", %{conn: conn, user: user} do

    conn = delete conn, session_path(conn, :delete, user)
    refute get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Signed out successfully!"
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
