import Config

config :logger,
  level: :debug

config :esctg, Esctg.Repo, database: "database.db"

config :esctg,
  ecto_repos: [Esctg.Repo],
  env: config_env()

per_env_file = "#{config_env()}.exs"

if File.exists?("config/" <> per_env_file) do
  import_config per_env_file
end
