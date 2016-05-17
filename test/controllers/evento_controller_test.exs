defmodule Odisseu.EventoControllerTest do
  use Odisseu.ConnCase
  #alias Odisseu.Evento
  alias Odisseu.TestHelper

  @valid_attrs %{ativo: true, data_extenso: "some content", descricao: "some content", extra: "some content", final: "2010-04-17 14:00:00", inicio: "2010-04-17 14:00:00", localizacao_gps: "some content", resumo: "some content", subtitulo: "some content", titulo: "some content", url_imagem: "some content", url_inscricao: "some content", url_maps: "some content"}
  @invalid_attrs %{data_extenso: nil, descricao: nil, extra: nil, final: nil, inicio: nil, localizacao_gps: nil, resumo: nil, subtitulo: nil, titulo: nil, url_imagem: nil, url_inscricao: nil, url_maps: nil}

  setup do
    {:ok, perfil}  = TestHelper.create_perfil(%{descricao: "user perfil", admin: false})
    {:ok, sede} = TestHelper.create_sede(%{email: "some content", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})
    {:ok, user} = TestHelper.create_user(perfil, sede, %{email: "test@test.com", username: "testuser", password: "test", password_confirmation: "test"})
    {:ok, evento} = TestHelper.create_evento(sede, %{ativo: true, data_extenso: "some content", descricao: "some content", extra: "some content", final: "2010-04-17 14:00:00", inicio: "2010-04-17 14:00:00", localizacao_gps: "some content", resumo: "some content", subtitulo: "some content", titulo: "some content", url_imagem: "some content", url_inscricao: "some content", url_maps: "some content"})

    conn = conn() |> login_user(user)
    {:ok, conn: conn, user: user, perfil: perfil, sede: sede, evento: evento}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  test "lists all entries on index", %{conn: conn, sede: sede} do
    conn = get conn, sede_evento_path(conn, :index, sede)
    assert html_response(conn, 200) =~ "Listing eventos"
  end

  test "shows chosen resource", %{conn: conn, sede: sede, evento: evento} do
    conn = get conn, sede_evento_path(conn, :show, sede, evento)
    assert html_response(conn, 200) =~ "Show evento"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, sede: sede} do
    assert_error_sent 404, fn ->
      get conn, sede_evento_path(conn, :show, sede, -1)
    end
  end

  test "redirects when the specified user does not exist", %{conn: conn} do
    conn = get conn, sede_evento_path(conn, :index, -1)
    assert get_flash(conn, :error) == "Invalid sede!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "redirects when trying to edit a post for a different user", %{conn: conn, user: _user, perfil: perfil, sede: sede, evento: evento} do
    {:ok, other_user} = TestHelper.create_user(perfil, sede, %{email: "test2@test.com", username: "test2", password: "test", password_confirmation: "test"})
    conn = get conn, sede_evento_path(conn, :edit, other_user, evento)
    assert get_flash(conn, :error) == "Invalid sede!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end
end
