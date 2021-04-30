defmodule Queue do
  use GenServer

  def start_link(initial_queue) when is_list(initial_queue) do
    GenServer.start_link(__MODULE__, initial_queue)
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :pop)
  end

  @impl true
  def init(queue) do
    {:ok, queue}
  end

  @impl true
  def handle_call({:push, element}, _from, state) do
    queue = state ++ [element]
    {:reply, queue, queue}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, [], []}
  end

  @impl true
  def handle_call(:pop, _from, [head | new_queue]) do
    {:reply, head, new_queue}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, state ++ [element]}
  end
end
