import Config

lvl =
  if config_env() == :prod do
    :info
  else
    :debug
  end

config :logger,
  level: lvl

config :esctg, Esctg.Repo, database: "database.db"

config :esctg,
  ecto_repos: [Esctg.Repo]
