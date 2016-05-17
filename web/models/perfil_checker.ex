defmodule Odisseu.PerfilChecker do
  alias Odisseu.Repo
  alias Odisseu.Perfil

  def is_admin?(user) do
    (perfil = Repo.get(Perfil, user.perfil_id)) && perfil.admin
  end
end
