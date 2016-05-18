defmodule Odisseu.SedeControllerTest do
  use Odisseu.ConnCase

  alias Odisseu.Sede
  @valid_attrs %{email: "some content", estado: "estado", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sede_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing sedes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, sede_path(conn, :new)
    assert html_response(conn, 200) =~ "New sede"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, sede_path(conn, :create), sede: @valid_attrs
    assert redirected_to(conn) == sede_path(conn, :index)
    assert Repo.get_by(Sede, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sede_path(conn, :create), sede: @invalid_attrs
    assert html_response(conn, 200) =~ "New sede"
  end

  test "shows chosen resource", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = get conn, sede_path(conn, :show, sede)
    assert html_response(conn, 200) =~ "Show sede"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, sede_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = get conn, sede_path(conn, :edit, sede)
    assert html_response(conn, 200) =~ "Edit sede"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = put conn, sede_path(conn, :update, sede), sede: @valid_attrs
    assert redirected_to(conn) == sede_path(conn, :show, sede)
    assert Repo.get_by(Sede, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = put conn, sede_path(conn, :update, sede), sede: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit sede"
  end

  test "deletes chosen resource", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = delete conn, sede_path(conn, :delete, sede)
    assert redirected_to(conn) == sede_path(conn, :index)
    refute Repo.get(Sede, sede.id)
  end
end
