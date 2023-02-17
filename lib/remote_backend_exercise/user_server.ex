defmodule RemoteBackendExercise.UserServer do
  use GenServer

  alias RemoteBackendExercise.Context.User
  require Logger

  def start_link(_args) do
    Logger.debug("Starting user server")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    :timer.send_interval(10_000, :update_points)
    {:ok, %{min_number: :rand.uniform(101), timestamp: nil}}
  end

  @impl true
  def handle_info(:update_points, state) do
    task = Task.async(fn -> User.update_all() end)
    state = Map.put(state, :min_number, :rand.uniform(101))
    Logger.debug("Nuevo valor de State #{inspect(state)}")
    {:noreply, state}
  end

  def get_users() do
    GenServer.call(__MODULE__, {:get_users})
  end

  @impl true
  def handle_call({:get_users}, _from, state) do
    min_number = Map.get(state, :min_number)
    users = User.get_users(min_number)

    {:ok, timestamp} = DateTime.now("Etc/UTC")
    state = Map.put(state, :timestamp, timestamp)

    result = Map.new()
    result = Map.put(result, :timestamp, DateTime.to_string(timestamp))
    result = Map.put(result, :users, users)

    {:reply, result, state}
  end
end
