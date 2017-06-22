defmodule Jod.SubmissionControllerTest do
  use Jod.ConnCase

  alias Jod.Submission
  alias Jod.User
  @valid_attrs %{data_url: "http://joss.theoj.org/", doi: "some content", metadata: %{}, review_issuer_id: 42, state: "some content", suggested_editor: 42, title: "some content"}
  @invalid_attrs %{}

  setup do
    {:ok, user} = create_user()
    conn = build_conn()
    |> login_user(user)
    {:ok, conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_submission_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing submissions"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_submission_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New submission"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, user_submission_path(conn, :create, user), submission: @valid_attrs
    assert redirected_to(conn) == user_submission_path(conn, :index, user)
    assert Repo.get_by(assoc(user, :submissions), @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, user_submission_path(conn, :create, user), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "New submission"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    submission = build_submission(user)
    conn = get conn, user, user_submission_path(conn, :show, user, submission)
    assert html_response(conn, 200) =~ "Show submission"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: user} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_submission_path(conn, :show, user, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    submission = build_submission(user)
    conn = get conn, user_submission_path(conn, :edit, user, submission)
    assert html_response(conn, 200) =~ "Edit Submission"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    submission = build_submission(user)
    conn = put conn, user_submission_path(conn, :update, user, submission), submission: @valid_attrs
    assert redirected_to(conn) == user_submission_path(conn, :show, user, submission)
    assert Repo.get_by(Submission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    submission = build_submission(user)
    conn = put conn, user_submission_path(conn, :update, user, submission), submission: %{"body" => nil}
    assert html_response(conn, 200) =~ "Edit Submission"
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    submission = build_submission(user)
    conn = delete conn, user_submission_path(conn, :delete, user, submission)
    assert redirected_to(conn) == user_submission_path(conn, :index, user)
    refute Repo.get(Submission, submission.id)
  end

  defp create_user do
    User.changeset(%User{}, %{email: "test@test.com", username: "test", password: "test", password_confirmation: "test", first_name: "test", last_name: "test"})
    |> Repo.insert
  end
  
  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  defp build_submission(user) do
    changeset =
      user
      |> build_assoc(:submissions)
      |> Submission.changeset(@valid_attrs)
    Repo.insert!(changeset)
  end
end
