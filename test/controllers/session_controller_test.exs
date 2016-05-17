defmodule Odisseu.SessionControllerTest do
  use Odisseu.ConnCase
  alias Odisseu.TestHelper

  setup do
    {:ok, perfil} = TestHelper.create_perfil(%{descricao: "User", admin: false})
    {:ok, sede} = TestHelper.create_sede(%{email: "some content", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})
    {:ok, _user} = TestHelper.create_user(perfil, sede, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates a new user session for a valid user", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "test", password: "test"}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Sign in successful!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create a session with a bad login", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "test", password: "wrong"}
    refute get_session(conn, :current_user)
    assert get_flash(conn, :error) == "Invalid username/password combination!"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create a session if user does not exist", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "foo", password: "wrong"}
    assert get_flash(conn, :error) == "Invalid username/password combination!"
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
