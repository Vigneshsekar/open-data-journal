defmodule Jod.UserTest do
  use Jod.ModelCase

  alias Jod.User

  @valid_attrs %{email: "testemail@gmail.com", first_name: "some content", last_name: "some content", password: "qwerty", password_confirmation:"qwerty" username: "testemail"}
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
