defmodule RemoteBackendExercise.UserHelper do
  @moduledoc """
  Helper functions 
  """

  @max_point_value 100

  @doc """
    Get a random integer between 0 and 100
  """
  @spec get_random_number() :: integer()
  def get_random_number() do
    :rand.uniform(@max_point_value)
  end
end
