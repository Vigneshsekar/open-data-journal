defmodule Jod.SessionControllerTest do
  use Jod.ConnCase
  alias Jod.User

  setup do
    User.changeset(%User{}, %{email: "test@email.com", first_name: "test", last_name: "user", password: "password", role_id: 1})
    |> Repo.insert
    {:ok, conn: build_conn()}
  end

  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "creates a new user session for a valid user", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{email: "test@email.com", password: "password"}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Logged In"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create a session with a bad login", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{email: "test@email.com", password: "wrong"}
    refute get_session(conn, :current_user)
    assert get_flash(conn, :error) == "Please check your credentials"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create a session if user does not exist", %{conn: conn} do    
    conn = post conn, session_path(conn, :create), user: %{email: "foo@foo.com", password: "wrong"}
    assert get_flash(conn, :error) == "Please check your credentials"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "deletes the user session", %{conn: conn} do
    user = Repo.get_by(User, %{email: "test@email.com"})
    conn = delete conn, session_path(conn, :delete, user)
    refute get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Logged out successfully."
    assert redirected_to(conn) == page_path(conn, :index)
  end
end