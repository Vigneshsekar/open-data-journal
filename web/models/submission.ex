defmodule Jod.Submission do
  use Jod.Web, :model

  schema "submissions" do
    field :title, :string
    field :metadata, :map
    belongs_to :user, Jod.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  @required_fields ~w(title metadata)a
  @optional_fields ~w()a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
  end
end
