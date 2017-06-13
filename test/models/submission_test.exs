defmodule Jod.SubmissionTest do
  use Jod.ModelCase

  alias Jod.Submission

  @valid_attrs %{metadata: %{}, title: "some content"}
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
