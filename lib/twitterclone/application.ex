defmodule Twitterclone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TwittercloneWeb.Telemetry,
      Twitterclone.Repo,
      {DNSCluster, query: Application.get_env(:twitterclone, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Twitterclone.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Twitterclone.Finch},
      # Start a worker by calling: Twitterclone.Worker.start_link(arg)
      # {Twitterclone.Worker, arg},
      # Start to serve requests, typically the last entry
      TwittercloneWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twitterclone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TwittercloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
