defmodule Odisseu.Router do
  use Odisseu.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Odisseu do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    resources "/sedes", SedeController do
        resources "/eventos", EventoController
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", Odisseu do
    pipe_through :api

    get "/searchSedes/:loc", Api.SedeController, :search

    get "/sedes/", Api.SedeController, :index
    get "/sedes/:id", Api.SedeController, :show

    get "/eventos/", Api.EventoController, :index
    get "/eventos/:id", Api.EventoController, :show
  end
end
