defmodule TheRush.Repo do
  use Ecto.Repo,
    otp_app: :the_rush,
    adapter: Ecto.Adapters.Postgres
end
