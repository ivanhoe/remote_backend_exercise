defmodule RemoteBackendExercise.User do
  @moduledoc """
  Schema to represent a User from the database.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias RemoteBackendExercise.User

  schema "users" do
    field(:points, :integer)
    timestamps()
  end

  @doc """
  Filter and validates the input received. 
  """
  @spec changeset(%User{}, map) :: %Ecto.Changeset{}
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:points])
    |> validate_required([:points])
  end
end
