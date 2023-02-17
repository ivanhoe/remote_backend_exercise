defmodule RemoteBackendExercise.UserServer do
  use GenServer

  alias RemoteBackendExercise.Context.User
  require Logger

  @max_point_value 101
  @interval :timer.seconds(60)

  def start_link(_args) do
    Logger.debug("Starting user server")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_users() do
    GenServer.call(__MODULE__, {:get_users})
  end

  @impl true
  def init(_) do
    update_user_points_every(@interval)
    {:ok, %{min_number: get_random_number(), timestamp: nil}}
  end

  @impl true
  def handle_info({:update_points}, state) do
    Task.start(fn -> User.update_all() end)
    update_user_points_every(@interval)
    {:noreply, Map.put(state, :min_number, get_random_number())}
  end

  @impl true
  def handle_call({:get_users}, _from, state) do
    min_number = Map.get(state, :min_number)
    users = User.get_users(min_number)

    {:ok, timestamp} = DateTime.now("Etc/UTC")
    state = Map.put(state, :timestamp, timestamp)

    result =
      Map.new()
      |> Map.put(:timestamp, DateTime.to_string(timestamp))
      |> Map.put(:users, users)

    {:reply, result, state}
  end

  # Helper functions

  defp update_user_points_every(interval) do
    __MODULE__
    |> Process.whereis()
    |> Process.send_after({:update_points}, interval)
  end

  defp get_random_number() do
    :rand.uniform(@max_point_value)
  end
end
