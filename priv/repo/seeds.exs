# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Odisseu.Repo.insert!(%Odisseu.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Odisseu.Repo
alias Odisseu.Perfil
alias Odisseu.Sede
alias Odisseu.User
import Ecto.Query, only: [from: 2]

find_or_create_perfil = fn perfil_descricao, admin ->
  case Repo.all(from p in Perfil, where: p.descricao == ^perfil_descricao and p.admin == ^admin) do
    [] ->
      %Perfil{}
      |> Perfil.changeset(%{descricao: perfil_descricao, admin: admin})
      |> Repo.insert!()
    _ ->
      IO.puts "Perfil: #{perfil_descricao} already exists, skipping"
  end
end

find_or_create_sede = fn sede_nome ->
  case Repo.all(from s in Sede, where: s.nome == ^sede_nome) do
    [] ->
      %Sede{}
      |> Sede.changeset(%{nome: sede_nome, estado: "Estado", email: "email@seed.com", endereco: "Endereco", localizacao_gps: "-99.99,99.99", telefone: "(65) 9234-5678", url_facebook: "/", url_imagem: "http://", url_instagram: "/", url_maps: "http://", url_ulisses: "http://"})
      |> Repo.insert!()
    _ ->
      IO.puts "Sede: #{sede_nome} already exists, skipping"
  end
end

find_or_create_user = fn username, email, perfil, sede ->
  case Repo.all(from u in User, where: u.username == ^username and u.email == ^email) do
    [] ->
      %User{}
      |> User.changeset(%{username: username, email: email, password: "test", password_confirmation: "test", perfil_id: perfil.id, sede_id: sede.id})
      |> Repo.insert!()
    _ ->
      IO.puts "User: #{username} already exists, skipping"
  end
end

_user_perfil = find_or_create_perfil.("Usuario", false)
admin_perfil = find_or_create_perfil.("Administrador", true)
sede         = find_or_create_sede.("Sede")
_admin_user  = find_or_create_user.("admin", "admin@test.com", admin_perfil, sede)
