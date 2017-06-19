defmodule Jod.UserControllerTest do
  use Jod.ConnCase

  alias Jod.User
  alias Jod.Repo

  @valid_create_attrs %{email: "test@email.com", first_name: "some content", last_name: "some content", password_hash: "some content", role_id: 1}
  @valid_attrs %{email: "test@email.com"}

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_create_attrs
    assert redirected_to(conn) == page_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_create_attrs
    assert redirected_to(conn) == user_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs)
  end

  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, Ecto.Changeset.get_change(changeset, :password_digest))
  end

  test "password_digest value does not get set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "tests@email.com", first_name: "some content", last_name: "some content", password: nil, role_id: 1})
    refute Ecto.Changeset.get_change(changeset, :password_digest)
  end

  
end
