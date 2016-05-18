defmodule Odisseu.UserTest do
  use Odisseu.ModelCase
  alias Odisseu.User
  alias Odisseu.TestHelper

  @valid_attrs %{email: "test@test.com", password: "test1234", password_confirmation: "test1234", username: "testuser"}
  @invalid_attrs %{}

  setup do
    {:ok, perfil}  = TestHelper.create_perfil(%{descricao: "user", admin: false})
    {:ok, sede} = TestHelper.create_sede(%{email: "some content" , estado: "estado", endereco: "some content", localizacao_gps: "some content", nome: "some content", telefone: "some content", url_facebook: "some content", url_imagem: "some content", url_instagram: "some content", url_maps: "some content", url_ulisses: "some content"})
    {:ok, perfil: perfil, sede: sede}
  end

  defp valid_attrs(perfil, sede) do
    valid_attrs_perfil = Map.put(@valid_attrs, :perfil_id, perfil.id)
    Map.put(valid_attrs_perfil, :sede_id, sede.id)
  end

  test "changeset with valid attributes", %{perfil: perfil, sede: sede} do
    changeset = User.changeset(%User{}, valid_attrs(perfil, sede))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, Ecto.Changeset.get_change(changeset, :hashed_password))
  end

  test "password_digest value does not get set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "test@test.com", password: nil, password_confirmation: nil, username: "test"})
    refute Ecto.Changeset.get_change(changeset, :hashed_password)
  end
end
