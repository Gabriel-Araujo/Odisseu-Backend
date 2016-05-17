defmodule Odisseu.EventoController do
  use Odisseu.Web, :controller

  alias Odisseu.Evento

  plug :scrub_params, "evento" when action in [:create, :update]
  plug :assign_sede
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]

  def index(conn, _params) do
    eventos = Repo.all(assoc(conn.assigns[:sede], :eventos))
    render(conn, "index.html", eventos: eventos)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:sede]
      |> build_assoc(:eventos)
      |> Evento.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"evento" => evento_params}) do
    changeset =
      conn.assigns[:sede]
      |> build_assoc(:eventos)
      |> Evento.changeset(evento_params)

    case Repo.insert(changeset) do
      {:ok, _evento} ->
        conn
        |> put_flash(:info, "Evento created successfully.")
        |> redirect(to: sede_evento_path(conn, :index, conn.assigns[:sede]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    evento = Repo.get!(assoc(conn.assigns[:sede], :eventos), id)
    render(conn, "show.html", evento: evento)
  end

  def edit(conn, %{"id" => id}) do
    evento = Repo.get!(assoc(conn.assigns[:sede], :eventos), id)
    changeset = Evento.changeset(evento)
    render(conn, "edit.html", evento: evento, changeset: changeset)
  end

  def update(conn, %{"id" => id, "evento" => evento_params}) do
    evento = Repo.get!(assoc(conn.assigns[:sede], :eventos), id)
    changeset = Evento.changeset(evento, evento_params)

    case Repo.update(changeset) do
      {:ok, evento} ->
        conn
        |> put_flash(:info, "Evento updated successfully.")
        |> redirect(to: sede_evento_path(conn, :show, conn.assigns[:sede], evento))
      {:error, changeset} ->
        render(conn, "edit.html", evento: evento, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    evento = Repo.get!(assoc(conn.assigns[:sede], :eventos), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(evento)

    conn
    |> put_flash(:info, "Evento deleted successfully.")
    |> redirect(to: sede_evento_path(conn, :index, conn.assigns[:sede]))
  end

  defp assign_sede(conn, _opts) do
    case conn.params do
      %{"sede_id" => sede_id} ->
        case Repo.get(Odisseu.Sede, sede_id) do
          nil -> invalid_sede(conn)
          sede -> assign(conn, :sede, sede)
        end
      _ ->
        invalid_sede(conn)
    end
  end

  defp invalid_sede(conn) do
    conn
    |> put_flash(:error, "Invalid sede!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)
    if user && (Integer.to_string(user.sede_id) == conn.params["id"] || Odisseu.PerfilChecker.is_admin?(user)) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

end
