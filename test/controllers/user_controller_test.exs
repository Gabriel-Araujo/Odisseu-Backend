defmodule Odisseu.UserControllerTest do
  use Odisseu.ConnCase
  alias Odisseu.User
  alias Odisseu.TestHelper

  @valid_create_attrs %{email: "test@test.com", password: "test1234", password_confirmation: "test1234", username: "testuser"}
  @valid_attrs %{email: "test@test.com", username: "testuser"}
  @invalid_attrs %{}

  setup do
    {:ok, sede} = TestHelper.create_sede(%{email: "some content", estado: "estado", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})

    {:ok, user_perfil}  = TestHelper.create_perfil(%{descricao: "user", admin: false})
    {:ok, nonadmin_user} = TestHelper.create_user(user_perfil, sede, %{username: "nonadmin", password: "test", password_confirmation: "test", email: "nonadmin@test.com"})

    {:ok, admin_perfil} = TestHelper.create_perfil(%{descricao: "admin", admin: true})
    {:ok, admin_user} = TestHelper.create_user(admin_perfil, sede, %{username: "admin", password: "test", password_confirmation: "test", email: "admin@test.com"})

    conn = conn()
    {:ok, conn: conn, user_perfil: user_perfil, nonadmin_user: nonadmin_user, admin_perfil: admin_perfil, admin_user: admin_user, sede: sede}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  defp valid_create_attrs(perfil, sede) do
    valid_create_attrs_perfil = Map.put(@valid_create_attrs, :perfil_id, perfil.id)
    Map.put(valid_create_attrs_perfil, :sede_id, sede.id)
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing users"
  end

  @tag admin: true
  test "renders form for new resources", %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

@tag admin: true
  test "redirects from new form when not admin", %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :new)
    assert get_flash(conn, :error) == "You are not authorized to create new users!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

@tag admin: true
  test "creates resource and redirects when data is valid", %{conn: conn, user_perfil: user_perfil, admin_user: admin_user, sede: sede} do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create), user: valid_create_attrs(user_perfil, sede)
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

@tag admin: true
  test "redirects from creating user when not admin", %{conn: conn, user_perfil: user_perfil, nonadmin_user: nonadmin_user, sede: sede} do
    conn = login_user(conn, nonadmin_user)
    conn = post conn, user_path(conn, :create), user: valid_create_attrs(user_perfil, sede)
    assert get_flash(conn, :error) == "You are not authorized to create new users!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

@tag admin: true
  test "does not create resource and renders errors when data is invalid", %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

@tag admin: true
  test "renders form for editing chosen resource when logged in as that user", %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, nonadmin_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

@tag admin: true
  test "renders form for editing chosen resource when logged in as an admin", %{conn: conn, admin_user: admin_user, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, admin_user)
    conn = get conn, user_path(conn, :edit, nonadmin_user)
    assert html_response(conn, 200) =~ "Edit user"
  end

@tag admin: true
  test "redirects away from editing when logged in as a different user", %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = get conn, user_path(conn, :edit, admin_user)
    assert get_flash(conn, :error) == "You are not authorized to modify that user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

@tag admin: true
  test "updates chosen resource and redirects when data is valid when logged in as that user", %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, nonadmin_user), user: @valid_create_attrs
    assert redirected_to(conn) == user_path(conn, :show, nonadmin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

@tag admin: true
  test "updates chosen resource and redirects when data is valid when logged in as an admin", %{conn: conn, admin_user: admin_user} do
    conn = login_user(conn, admin_user)
    conn = put conn, user_path(conn, :update, admin_user), user: @valid_create_attrs
    assert redirected_to(conn) == user_path(conn, :show, admin_user)
    assert Repo.get_by(User, @valid_attrs)
  end

@tag admin: true
  test "does not update chosen resource when logged in as different user", %{conn: conn, nonadmin_user: nonadmin_user, admin_user: admin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, admin_user), user: @valid_create_attrs
    assert get_flash(conn, :error) == "You are not authorized to modify that user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

@tag admin: true
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, nonadmin_user: nonadmin_user} do
    conn = login_user(conn, nonadmin_user)
    conn = put conn, user_path(conn, :update, nonadmin_user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

@tag admin: true
  test "deletes chosen resource when logged in as that user", %{conn: conn, user_perfil: user_perfil, sede: sede} do
    {:ok, user} = TestHelper.create_user(user_perfil, sede, @valid_create_attrs)
    conn =
      login_user(conn, user)
      |> delete(user_path(conn, :delete, user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end

@tag admin: true
  test "deletes chosen resource when logged in as an admin", %{conn: conn, user_perfil: user_perfil, admin_user: admin_user, sede: sede} do
    {:ok, user} = TestHelper.create_user(user_perfil, sede, @valid_create_attrs)
    conn =
      login_user(conn, admin_user)
      |> delete(user_path(conn, :delete, user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end

@tag admin: true
  test "redirects away from deleting chosen resource when logged in as a different user", %{conn: conn, user_perfil: user_perfil, nonadmin_user: nonadmin_user, sede: sede} do
    {:ok, user} = TestHelper.create_user(user_perfil, sede, @valid_create_attrs)
    conn =
      login_user(conn, nonadmin_user)
      |> delete(user_path(conn, :delete, user))
    assert get_flash(conn, :error) == "You are not authorized to modify that user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

end
