defmodule Jod.UserTest do
  use Jod.ModelCase

  alias Jod.User

  @valid_attrs %{email: "testemail@gmail.com", first_name: "some content", last_name: "some content", password: "qwerty", password_confirmation: "qwerty", username: "testemail"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "Password value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, 
                                   Ecto.Changeset.get_change(changeset, :password_hash))
  end

  # But will a nil occurance of the password happen?
  test "Password doen't get set if the password entered is nil" do
    changeset = User.changeset(%User{}, %{email: "testemail@gmail.com",
                                          first_name: "some content",
                                          last_name: "some content",
                                          password: nil,
                                          password_confirmation: nil,
                                          username: "testemail"
                                          })
    refute Ecto.Changeset.get_change(changeset, :password_hash)
  end
end
