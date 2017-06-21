use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :jod, Jod.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :jod, Jod.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "jod_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# To speed-up the tests. Not to spend too much time on encrypting the password.
config :comeonin, bcrypt_log_rounds: 4
