# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :vaccine_tracker,
  ecto_repos: [VaccineTracker.Repo],
  time_zone_database: Tzdata.TimeZoneDatabase

# Configures the endpoint
config :vaccine_tracker, VaccineTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "a4UA4AfAAKSfgoXNUqKr/2ZgH4RnO7M45DUNYoG/RByGGfqNuV1/Gi/ggK83R/RZ",
  render_errors: [view: VaccineTrackerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: VaccineTracker.PubSub,
  live_view: [signing_salt: "ujFmGPLg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
