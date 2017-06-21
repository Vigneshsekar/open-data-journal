defmodule Jod.SubmissionTest do
  use Jod.ModelCase

  alias Jod.Submission

  @valid_attrs %{data_url: "some content", doi: "some content", metadata: %{}, review_issuer_id: 42, state: "some content", suggested_editor: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Submission.changeset(%Submission{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Submission.changeset(%Submission{}, @invalid_attrs)
    refute changeset.valid?
  end
end
