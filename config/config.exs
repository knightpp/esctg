import Config

config :esctg, Esctg.Repo, database: "database.db"

config :esctg,
  ecto_repos: [Esctg.Repo]
