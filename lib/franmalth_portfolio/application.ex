defmodule FranmalthPortfolio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FranmalthPortfolioWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:franmalth_portfolio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FranmalthPortfolio.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FranmalthPortfolio.Finch},
      # Start a worker by calling: FranmalthPortfolio.Worker.start_link(arg)
      # {FranmalthPortfolio.Worker, arg},
      # Start to serve requests, typically the last entry
      FranmalthPortfolioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FranmalthPortfolio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FranmalthPortfolioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
