defmodule Esctg.Repo do
  use Ecto.Repo,
    otp_app: :esctg,
    adapter: Ecto.Adapters.SQLite3
end
