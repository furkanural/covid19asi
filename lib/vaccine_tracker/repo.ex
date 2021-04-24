defmodule VaccineTracker.Repo do
  use Ecto.Repo,
    otp_app: :vaccine_tracker,
    adapter: Ecto.Adapters.Postgres
end
