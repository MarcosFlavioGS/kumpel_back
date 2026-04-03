defmodule KumpelBackWeb.ApiRouter do
  @moduledoc """
  JSON API routes under `/api`.

  Mounted from `KumpelBackWeb.Router` via `forward "/api", __MODULE__` so all API
  wiring lives in one place while the top-level router stays focused on browser
  pages, dev tools, and other plugs.
  """

  use KumpelBackWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug KumpelBackWeb.Plugs.Auth
  end

  # Public API — no Bearer token
  scope "/", KumpelBackWeb do
    pipe_through :api

    get "/health", Health.HealthController, :index

    resources "/rooms", Rooms.RoomsController, only: [:show, :index]
    resources "/users", Users.UsersController, only: [:create, :show, :index]

    post "/auth/login", Auth.AuthController, :login
  end

  # Authenticated API — Bearer access token
  scope "/", KumpelBackWeb do
    pipe_through [:api, :auth]

    resources "/rooms", Rooms.RoomsController, only: [:create, :update, :delete]
    post "/rooms/subscribe", Subscription.SubscriptionController, :subscribe

    resources "/users", Users.UsersController, only: [:update, :delete]
    get "/currentUser", Users.UsersController, :current
  end
end
