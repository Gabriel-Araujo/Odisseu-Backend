defmodule Odisseu.UserView do
  use Odisseu.Web, :view

  def perfils_for_select(perfils) do
    perfils
    |> Enum.map(&["#{&1.descricao}": &1.id])
    |> List.flatten
  end
end
