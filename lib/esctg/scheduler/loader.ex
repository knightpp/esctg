defmodule Esctg.Scheduler.Loader do
  use Task

  require Logger
  import Ecto.Query, only: [from: 2]
  alias Esctg.Channel
  alias Esctg.Repo

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  def run(_arg) do
    if Application.get_env(:esctg, :env) == :test do
      Logger.debug("detected test env, skipping loader...")
    else
      chans = Repo.all(from(c in Channel, where: c.enabled == true))
      Logger.info("found #{Enum.count(chans)} enabled channels")
      chans |> Enum.each(&Esctg.Scheduler.Supervisor.start_child/1)
    end
  end
end
