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

Enum.each(1..1_000_000, fn _ ->
    RemoteBackendExercise.Repo.insert!(%RemoteBackendExercise.User{
    points: 0
  })
end)