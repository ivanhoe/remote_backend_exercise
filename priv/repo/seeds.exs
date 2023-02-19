# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RemoteBackendExercise.Repo.insert!(%RemoteBackendExercise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ecto.Multi
alias RemoteBackendExercise.{Repo, User}

1..1_000_000
|> Enum.reduce(Multi.new(), fn index, multi ->
  unique_identifier =
    index
    |> Integer.to_string()
    |> String.to_atom()

  Multi.insert(multi, unique_identifier, %User{points: 0})
end)
|> Repo.transaction(timeout: :infinity)
