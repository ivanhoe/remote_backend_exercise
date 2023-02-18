defmodule RemoteBackendExercise.UserWorker do
  use GenServer

  require Logger
  alias RemoteBackendExercise.Context.User

  @time_out 20_000
  @max_point_value 100

  @doc """
  Start a new GenServer
  """
  @spec start_link(any()) :: {:ok, pid}
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  @doc """
  Updates point attribute in all the Users.
  """
  @spec update_user_point(list()) :: {:ok, pid}
  def update_user_point(users) do
    Task.start(fn ->
      :poolboy.transaction(
        :user_worker,
        fn pid ->
          GenServer.call(pid, {:update_user_point, users}, @time_out)
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
  def handle_call({:update_user_point, users}, _from, state) do
    Enum.each(users, fn user ->
      User.update(user, %{points: :rand.uniform(@max_point_value)})
    end)

    {:reply, "response", state}
  end
end
