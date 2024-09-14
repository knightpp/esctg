defmodule Esctg.Scheduler do
  use GenServer
  require Logger

  alias Esctg.Channel

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  @impl GenServer
  def init({req, %Channel{} = chan}) do
    {:ok, {req, chan}, {:continue, :ok}}
  end

  @impl GenServer
  def handle_info(:timeout, {req, chan}) do
    info = Esctg.Scanner.scan_new!(req, chan)
    Logger.debug("channel #{info.title} has #{Enum.count(info.messages)} new messages")
    Esctg.Poster.post!(chan, info.messages)
    {:noreply, chan, :timer.hours(1)}
  end

  @impl GenServer
  def handle_continue(:ok, {req, chan}) do
    # first time it should not wait to give supervisor an ability to kill itself
    Logger.info("initializing scheduler for #{chan.title}")
    handle_info(:timeout, {req, chan})
  end
end
