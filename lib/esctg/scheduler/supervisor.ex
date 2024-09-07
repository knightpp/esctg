defmodule Esctg.Scheduler.Supervisor do
  use DynamicSupervisor

  def start_child(%Esctg.Channel{} = chan) do
    DynamicSupervisor.start_child(__MODULE__, {Esctg.Scheduler, chan})
  end

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl DynamicSupervisor
  def init(_arg) do
    DynamicSupervisor.init(restart_strategy: :one_for_one)
  end
end
