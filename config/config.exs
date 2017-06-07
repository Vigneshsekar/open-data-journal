# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :jod,
  ecto_repos: [Jod.Repo]

# Configures the endpoint
config :jod, Jod.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NosSnqqjUzFUQbOxayAyUFOkyQdjqZcMrklBHJU8sGepaj2Ly1ca8inG6ZkXBsna",
  render_errors: [view: Jod.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jod.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configures Guardian - an authentication framework for use with elixir applications
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Jod",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "ftie+gQEvSTh+9z8cnAZrBj9q1j/RTM2DrW66a3t61kTGMMKgVRfleZ3IQuPtCqu",
  serializer: Jod.GuardianSerializer