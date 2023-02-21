defmodule RemoteBackendExercise.UserControllerTest do
  use RemoteBackendExerciseWeb.ConnCase

  alias RemoteBackendExercise.UserHelper
  alias RemoteBackendExercise.Repo
  alias RemoteBackendExercise.User

  setup do
    Enum.map(1..1_000, fn _ ->
      Repo.insert!(%User{points: UserHelper.get_random_number()})
    end)

    :ok
  end

  describe "users" do
    test "get two with random points values", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :get_users))
      response = json_response(conn, 200)

      assert Map.has_key?(response, "timestamp")
      assert Map.has_key?(response, "users")

      %{"timestamp" => _timestamp, "users" => users} = response
      assert length(users) == 2
    end
  end
end
