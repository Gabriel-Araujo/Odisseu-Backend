defmodule Odisseu.Api.SedeControllerTest do
  use Odisseu.ConnCase

  alias Odisseu.Api.Sede
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, sede_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = get conn, sede_path(conn, :show, sede)
    assert json_response(conn, 200)["data"] == %{"id" => sede.id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, sede_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, sede_path(conn, :create), sede: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Sede, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, sede_path(conn, :create), sede: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = put conn, sede_path(conn, :update, sede), sede: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Sede, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = put conn, sede_path(conn, :update, sede), sede: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    sede = Repo.insert! %Sede{}
    conn = delete conn, sede_path(conn, :delete, sede)
    assert response(conn, 204)
    refute Repo.get(Sede, sede.id)
  end
end
