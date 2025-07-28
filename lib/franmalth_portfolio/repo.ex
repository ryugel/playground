defmodule FranmalthPortfolio.Repo do
  use Ecto.Repo,
    otp_app: :franmalth_portfolio,
    adapter: Ecto.Adapters.Postgres
end
