defmodule KumpelBack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      KumpelBackWeb.Telemetry,
      KumpelBack.Repo,
      {DNSCluster, query: Application.get_env(:kumpel_back, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: KumpelBack.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: KumpelBack.Finch},
      # Start a worker by calling: KumpelBack.Worker.start_link(arg)
      # {KumpelBack.Worker, arg},
      # Start to serve requests, typically the last entry
      KumpelBackWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KumpelBack.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KumpelBackWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
