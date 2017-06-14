defmodule Jod.Role do
  use Jod.Web, :model

  schema "roles" do
    field :name, :string

    has_many :users, Jod.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
