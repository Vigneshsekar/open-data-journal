defmodule Jod.UserTest do
  use Jod.ModelCase

  alias Jod.User

  @valid_attrs %{email: "test@email.com", first_name: "some content", last_name: "some content", password_hash: "some content", role_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
