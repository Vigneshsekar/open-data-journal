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

    timestamps()

    belongs_to :user, Jod.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :state, :data_url, :doi, :review_issuer_id, :suggested_editor])
    |> validate_required([:title, :state, :data_url, :doi, :review_issuer_id, :suggested_editor])
  end
end
