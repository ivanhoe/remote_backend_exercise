defmodule RemoteBackendExercise.Context.User do
  @moduledoc """
  The User context.
  """

  use Ecto.Schema
  import Ecto.Query, warn: false

  alias RemoteBackendExercise.{User, Repo, UserWorker, UserHelper}
  require Logger

  @ten_thousand_users 10_000
  @max_users 2

  @doc """
  Update all users in batch
  """
  @spec update_users_in_batch() :: {:ok, any()}
  def update_users_in_batch() do
    Repo.transaction(
      fn ->
        from(u in User)
        |> Repo.stream()
        |> Stream.chunk_every(@ten_thousand_users)
        |> Stream.each(fn users ->
          UserWorker.update_user_points(users)
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  @doc """
  Update points attribute from a batch of users in a transaction
  """
  @spec update_points(list()) :: {:ok, any()}
  def update_points(users) do
    users
    |> Enum.reduce(Ecto.Multi.new(), fn user, multi ->
      Ecto.Multi.update(
        multi,
        {:user, user.id},
        User.changeset(user, %{points: UserHelper.get_random_number()})
      )
    end)
    |> Repo.transaction()
  end

  @doc """
  Get two users greater than min_number
  """
  @spec get_two_with_points_greater_than(integer()) :: list()
  def get_two_with_points_greater_than(min_number) do
    {:ok, users} =
      Repo.transaction(fn ->
        from(u in User,
          where: u.points > ^min_number,
          limit: @max_users
        )
        |> Repo.stream()
        |> Enum.map(fn user ->
          %{id: user.id, points: user.points}
        end)
      end)

    users
  end
end
