defmodule RemoteBackendExercise.Context.User do
  @moduledoc """
  The User context.
  """

  require Logger

  import Ecto.Query, warn: false
  alias RemoteBackendExercise.{User, Repo}
  use Ecto.Schema

  @doc """
  Updates a user.
  """
  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_all() do
    Repo.transaction(
      fn ->
        from(u in User)
        |> Repo.stream()
        |> Stream.map(fn user ->
          __MODULE__.update(user, %{points: :rand.uniform(101)})
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  def get_users(min_number) do
    Logger.debug("Valor de min_number = #{min_number}")

    {:ok, users} =
      Repo.transaction(
        fn ->
          from(u in User,
            where: u.points > ^min_number,
            limit: 2
          )
          |> Repo.stream()
          |> Enum.map(fn user ->
            %{id: user.id, points: user.points}
          end)
        end,
        timeout: :infinity
      )

    Logger.debug("Usuarios obtenidos #{inspect(users)}")
    users
  end
end
