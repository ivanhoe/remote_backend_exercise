defmodule RemoteBackendExerciseWeb.UserController do
  @moduledoc """
  Controller to get users response
  """
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
