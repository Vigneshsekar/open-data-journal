defmodule Jod.SubmissionController do
  use Jod.Web, :controller

  alias Jod.Submission
  alias Jod.User

  plug :scrub_params, "submission" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get!(user_id)
    submissions =
      user
      |> user_submissions
      |> Repo.all
      |> Repo.preload(:user)
    render(conn, "index.html", submissions: submissions, user: user)
  end

  def show(conn, %{"user_id" => user_id, "id" => id},
                                       _current_user) do
    user = User |> Repo.get!(user_id)
    submission = user |> user_submission_by_id(id) |> Repo.preload(:user)
    render(conn, "show.html", submission: submission, user: user)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:submissions)
      |> Submission.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"submission" => submission_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:submissions)
      |> Submission.changeset(submission_params)
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Submission is made successfully")
        |> redirect(to: user_submission_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    submission = current_user |> user_submission_by_id(id)
    changeset = Submission.changeset(submission)
    render(conn, "edit.html", submission: submission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "submission" => submission_params},
                                                      current_user) do
    submission = current_user |> user_submission_by_id(id)
    changeset = Submission.changeset(submission, submission_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Your submission is updated successfully")
        |> redirect(to: user_submission_path(conn, :show, current_user.id, 
                                      submission.id))
      {:error, changeset} ->
        render(conn, "edit.html", submission: submission, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    current_user |> user_submission_path(id) |> Repo.delete!
    conn
    |> put_flash(:info, "Your submission is deleted successfully")
    |> redirect(to: user_submission_path(conn, :index, current_user.id))
  end

  defp user_submissions(user) do
    assoc(user, :submissions)
  end

  defp user_submission_by_id(user, submission_id) do
    user
    |> user_submissions
    |> Repo.get(submission_id)
  end
end