defmodule Esctg.Scheduler do
  use GenServer
  require Logger

  alias Esctg.Channel

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl GenServer
  def init(%Channel{} = chan) do
    {:ok, chan, {:continue, :ok}}
  end

  @impl GenServer
  def handle_info(:timeout, chan) do
    info = Esctg.Scanner.scan_new!(chan)
    Esctg.Poster.post!(chan, info.messages)
    {:noreply, chan, :timer.hours(1)}
  end

  @impl GenServer
  def handle_continue(:ok, chan) do
    # first time it should not wait to give supervisor an ability to kill itself
    Logger.info("initializing scheduler for #{chan.title}")
    handle_info(:timeout, chan)
  end
end
