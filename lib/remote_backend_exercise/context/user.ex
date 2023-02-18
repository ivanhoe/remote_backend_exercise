defmodule RemoteBackendExercise.Context.User do
  @moduledoc """
  The User context.
  """

  use Ecto.Schema
  import Ecto.Query, warn: false

  alias RemoteBackendExercise.{User, Repo, UserWorker}
  require Logger

  @ten_thousand_users 10_000

  @doc """
  Updates a user.
  """
  @spec update(%User{}, map) :: {:ok, %User{}}
  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Update all users.
  """
  @spec update_all() :: {:ok, any()}
  def update_all() do
    Repo.transaction(
      fn ->
        from(u in User)
        |> Repo.stream()
        |> Stream.chunk_every(@ten_thousand_users)
        |> Stream.each(fn users ->
          UserWorker.update_user_point(users)
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  @doc """
  Get two users greater than min_number
  """
  @spec get_users(integer()) :: list()
  def get_users(min_number) do
    {:ok, users} =
      Repo.transaction(fn ->
        from(u in User,
          where: u.points > ^min_number,
          limit: 2
        )
        |> Repo.stream()
        |> Enum.map(fn user ->
          %{id: user.id, points: user.points}
        end)
      end)

    users
  end
end
