defmodule RemoteBackendExercise.UserWorker do
  @moduledoc """
  Updates all the users using a worker available 
  from the pool.
  """

  use GenServer

  require Logger
  alias RemoteBackendExercise.Context.User

  @time_out 20_000

  @doc """
  Start a new GenServer
  """
  @spec start_link(any()) :: {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  @doc """
  Create a new process to invoke a worker available 
  from the pool to update the users point
  """
  @spec update_user_points(list()) :: {:ok, pid}
  def update_user_points(users) do
    Task.start(fn ->
      :poolboy.transaction(
        :user_worker,
        fn pid ->
          GenServer.call(pid, {:update_user_points, users}, @time_out)
        end,
        :infinity
      )
    end)
  end

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:update_user_points, users}, _from, state) do
    User.update_points(users)
    {:reply, nil, state}
  end
end
