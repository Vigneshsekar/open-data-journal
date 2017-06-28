defmodule Jod.Submission do
  use Jod.Web, :model

  schema "submissions" do
    field :title, :string
    field :state, :string
    field :data_url, :string
    field :doi, :string
    field :metadata, :map
    field :review_issuer_id, :integer
    field :suggested_editor, :integer
    field :description, :string

    timestamps()

    belongs_to :user, Jod.User
    has_many :comments, Jod.Comment
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :data_url])
    |> validate_required([:title, :description, :data_url])
  end
end
