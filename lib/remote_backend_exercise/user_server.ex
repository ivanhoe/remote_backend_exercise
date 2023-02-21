defmodule RemoteBackendExercise.UserServer do
  @moduledoc """
  Updates all the users point every 60 seconds and 
  get two users with the last timestamp obtained. 
  """

  use GenServer

  alias RemoteBackendExercise.Context.User
  alias RemoteBackendExercise.UserHelper
  require Logger

  @interval :timer.seconds(60)

  @doc """
  Start a new GenServer
  """
  @spec start_link(any()) :: {:ok, pid}
  def start_link(_args) do
    Logger.debug("Starting user server")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Get a map with 2 users and the last timestamp consulted
  """
  @spec get_users() :: map()
  def get_users() do
    GenServer.call(__MODULE__, {:get_users})
  end

  @impl true
  def init(_) do
    update_user_points_every(@interval)
    {:ok, %{min_number: UserHelper.get_random_number(), timestamp: nil}}
  end

  @impl true
  def handle_info({:update_points}, state) do
    Task.start(fn -> User.update_users_in_batch() end)
    update_user_points_every(@interval)
    {:noreply, Map.put(state, :min_number, UserHelper.get_random_number())}
  end

  @impl true
  def handle_call({:get_users}, _from, state) do
    min_number = Map.get(state, :min_number)
    users = User.get_two_with_points_greater_than(min_number)

    {:ok, timestamp} = DateTime.now("Etc/UTC")
    timestamp = DateTime.truncate(timestamp, :second)

    state = Map.put(state, :timestamp, timestamp)

    result =
      Map.new()
      |> Map.put(:timestamp, DateTime.to_string(timestamp))
      |> Map.put(:users, users)

    {:reply, result, state}
  end

  # Helper function
  @spec update_user_points_every(integer()) :: any()
  defp update_user_points_every(interval) do
    __MODULE__
    |> Process.whereis()
    |> Process.send_after({:update_points}, interval)
  end
end
