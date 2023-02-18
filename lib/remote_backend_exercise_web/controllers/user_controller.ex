defmodule RemoteBackendExerciseWeb.UserController do
  use RemoteBackendExerciseWeb, :controller

  alias RemoteBackendExercise.UserServer

  @doc """
  Get a map of two users and the last timestamp consulted
  """
  @spec get_users(%Plug.Conn{}, map) :: %Plug.Conn{}
  def get_users(conn, _params) do
    json(conn, UserServer.get_users())
  end
end
