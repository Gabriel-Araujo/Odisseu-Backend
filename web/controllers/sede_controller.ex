defmodule Odisseu.SedeController do
  use Odisseu.Web, :controller

  alias Odisseu.Sede

  plug :scrub_params, "sede" when action in [:create, :update]

  def index(conn, _params) do
    sedes = Repo.all(Sede)
    render(conn, "index.html", sedes: sedes)
  end

  def new(conn, _params) do
    changeset = Sede.changeset(%Sede{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sede" => sede_params}) do
    changeset = Sede.changeset(%Sede{}, sede_params)

    case Repo.insert(changeset) do
      {:ok, _sede} ->
        conn
        |> put_flash(:info, "Sede created successfully.")
        |> redirect(to: sede_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sede = Repo.get!(Sede, id)
    render(conn, "show.html", sede: sede)
  end

  def edit(conn, %{"id" => id}) do
    sede = Repo.get!(Sede, id)
    changeset = Sede.changeset(sede)
    render(conn, "edit.html", sede: sede, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sede" => sede_params}) do
    sede = Repo.get!(Sede, id)
    changeset = Sede.changeset(sede, sede_params)

    case Repo.update(changeset) do
      {:ok, sede} ->
        conn
        |> put_flash(:info, "Sede updated successfully.")
        |> redirect(to: sede_path(conn, :show, sede))
      {:error, changeset} ->
        render(conn, "edit.html", sede: sede, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sede = Repo.get!(Sede, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sede)

    conn
    |> put_flash(:info, "Sede deleted successfully.")
    |> redirect(to: sede_path(conn, :index))
  end
end
