defmodule Odisseu.Api.EventoController do
  use Odisseu.Web, :controller

  alias Odisseu.Evento

  plug :scrub_params, "evento" when action in [:create, :update]

  def index(conn, _params) do
    eventos = Repo.all(Evento)
    render(conn, "index.json", eventos: eventos)
  end

  def create(conn, %{"evento" => evento_params}) do
    changeset = Evento.changeset(%Evento{}, evento_params)

    case Repo.insert(changeset) do
      {:ok, evento} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", evento_path(conn, :show, evento))
        |> render("show.json", evento: evento)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Odisseu.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    evento = Repo.get!(Evento, id)
    render(conn, "show.json", evento: evento)
  end

  def update(conn, %{"id" => id, "evento" => evento_params}) do
    evento = Repo.get!(Evento, id)
    changeset = Evento.changeset(evento, evento_params)

    case Repo.update(changeset) do
      {:ok, evento} ->
        render(conn, "show.json", evento: evento)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Odisseu.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    evento = Repo.get!(Evento, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(evento)

    send_resp(conn, :no_content, "")
  end
end
