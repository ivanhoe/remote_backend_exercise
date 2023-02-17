defmodule RemoteBackendExerciseWeb.Router do
  use RemoteBackendExerciseWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RemoteBackendExerciseWeb do
    pipe_through :api
  end

  scope "/", RemoteBackendExerciseWeb do
    get "/", UserController, :get_users
  end
end
