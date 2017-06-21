defmodule Jod.SubmissionControllerTest do
  use Jod.ConnCase

  alias Jod.Submission
  @valid_attrs %{data_url: "http://joss.theoj.org/", doi: "some content", metadata: %{}, review_issuer_id: 42, state: "some content", suggested_editor: 42, title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, submission_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing submissions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, submission_path(conn, :new)
    assert html_response(conn, 200) =~ "New submission"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, submission_path(conn, :create), submission: @valid_attrs
    assert redirected_to(conn) == submission_path(conn, :index)
    assert Repo.get_by(Submission, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, submission_path(conn, :create), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "New submission"
  end

  test "shows chosen resource", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = get conn, submission_path(conn, :show, submission)
    assert html_response(conn, 200) =~ "Show submission"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, submission_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = get conn, submission_path(conn, :edit, submission)
    assert html_response(conn, 200) =~ "Edit submission"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = put conn, submission_path(conn, :update, submission), submission: @valid_attrs
    assert redirected_to(conn) == submission_path(conn, :show, submission)
    assert Repo.get_by(Submission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = put conn, submission_path(conn, :update, submission), submission: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit submission"
  end

  test "deletes chosen resource", %{conn: conn} do
    submission = Repo.insert! %Submission{}
    conn = delete conn, submission_path(conn, :delete, submission)
    assert redirected_to(conn) == submission_path(conn, :index)
    refute Repo.get(Submission, submission.id)
  end
end
