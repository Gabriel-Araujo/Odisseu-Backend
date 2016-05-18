defmodule Odisseu.Api.EventoControllerTest do
  use Odisseu.ConnCase

  alias Odisseu.Api.Evento
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, evento_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    evento = Repo.insert! %Evento{}
    conn = get conn, evento_path(conn, :show, evento)
    assert json_response(conn, 200)["data"] == %{"id" => evento.id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, evento_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, evento_path(conn, :create), evento: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Evento, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, evento_path(conn, :create), evento: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    evento = Repo.insert! %Evento{}
    conn = put conn, evento_path(conn, :update, evento), evento: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Evento, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    evento = Repo.insert! %Evento{}
    conn = put conn, evento_path(conn, :update, evento), evento: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    evento = Repo.insert! %Evento{}
    conn = delete conn, evento_path(conn, :delete, evento)
    assert response(conn, 204)
    refute Repo.get(Evento, evento.id)
  end
end
