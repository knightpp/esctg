priv = Path.join(Application.app_dir(:esctg), "priv")
Code.require_file("repo/migrations/20240901100155_create_seen.exs", priv)
Code.require_file("repo/migrations/20240901100434_create_channels.exs", priv)

ExUnit.start()
