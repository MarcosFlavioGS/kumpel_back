defmodule KumpelBackWeb.Router do
  use KumpelBackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {KumpelBackWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KumpelBackWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", KumpelBackWeb do
    pipe_through :api

    # Health
    get "/health", Health.HealthController, :index

    # Rooms
    resources "/rooms", Rooms.RoomsController, only: [:create, :update, :delete, :show, :index]

    # Users
    resources "/users", Users.UsersController, only: [:create, :update, :delete, :show, :index]

    # Auth
    post "/auth/login", Auth.AuthController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", KumpelBackWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:kumpel_back, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: KumpelBackWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
