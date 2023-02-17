defmodule RemoteBackendExerciseWeb.UserController do
  use RemoteBackendExerciseWeb, :controller

  alias RemoteBackendExerciseWeb.UserServer

  def get_users(conn, _params) do
    json(conn, UserServer.get_users())
  end
end
