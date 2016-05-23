defmodule Odisseu.Api.SedeController do
  use Odisseu.Web, :controller

  alias Odisseu.Sede

  plug :scrub_params, "sede" when action in [:create, :update]

  def index(conn, _params) do
    sedes = Repo.all from s in Sede, order_by: [s.estado, s.nome]
    render(conn, "index.json", sedes: sedes)
  end

  def create(conn, %{"sede" => sede_params}) do
    changeset = Sede.changeset(%Sede{}, sede_params)

    case Repo.insert(changeset) do
      {:ok, sede} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", sede_path(conn, :show, sede))
        |> render("show.json", sede: sede)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Odisseu.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sede = Repo.get!(Sede, id)
    render(conn, "show.json", sede: sede)
  end

  def update(conn, %{"id" => id, "sede" => sede_params}) do
    sede = Repo.get!(Sede, id)
    changeset = Sede.changeset(sede, sede_params)

    case Repo.update(changeset) do
      {:ok, sede} ->
        render(conn, "show.json", sede: sede)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Odisseu.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sede = Repo.get!(Sede, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sede)

    send_resp(conn, :no_content, "")
  end
end
