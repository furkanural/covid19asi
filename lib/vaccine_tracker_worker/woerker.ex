defmodule VaccineTrackerWorker.Worker do
  use GenServer

  import VaccineTrackerWorker.CrawlerWorker

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # first_call()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # perform()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 900000) # In 15 minutes
  end

  defp first_call() do
    Process.send(self(), :work, [:noconnect])
  end
end
