defmodule Esctg.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Esctg.Repo,
      Esctg.Scheduler.Supervisor,
      Esctg.Scheduler.Loader
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
