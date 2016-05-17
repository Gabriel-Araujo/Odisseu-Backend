defmodule Odisseu.User do
  use Odisseu.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :username, :string
    field :email, :string
    field :hashed_password, :string
    belongs_to :sede, Odisseu.Sede
    belongs_to :perfil, Odisseu.Perfil

    timestamps

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end

  @required_fields ~w(username email password password_confirmation sede_id perfil_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:hashed_password, hashpwsalt(password))
    else
      changeset
    end
  end
end
