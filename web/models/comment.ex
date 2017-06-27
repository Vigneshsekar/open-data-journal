defmodule Jod.Comment do
  use Jod.Web, :model

  schema "comments" do
    field :author, :string
    field :body, :string
    field :approved, :boolean, default: true
    belongs_to :submission, Jod.Submission
    belongs_to :user, Jod.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:author, :body, :approved])
    |> validate_required([:author, :body, :approved])
  end
end
