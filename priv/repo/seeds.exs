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

perfil = %Perfil{}
  |> Perfil.changeset(%{descricao: "Administrador", admin: true})
  |> Repo.insert!

sede = %Sede{}
  |> Sede.changeset(%{email: "email@seed.com", endereco: "Endereco", localizacao_gps: "-99.99,99.99", nome: "Nome Sede", telefone: "(65) 9234-5678", url_facebook: "/", url_imagem: "http://", url_instagram: "/", url_maps: "http://", url_ulisses: "http://"})
  |> Repo.insert!

admin = %User{}
  |> User.changeset(%{username: "admin", email: "admin@test.com", password: "test", password_confirmation: "test", perfil_id: perfil.id, sede_id: sede.id})
  |> Repo.insert!
