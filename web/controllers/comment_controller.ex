defmodule Jod.CommentController do
  use Jod.Web, :controller

  alias Jod.Comment
  alias Jod.Submission
  plug :scrub_params, "comment" when action in [:create, :update]
  plug :set_submission_and_authorize_user when action in [:update, :delete]

  def create(conn, %{"comment" => comment_params, "submission_id" => submission_id}) do
    user = get_session(conn, :current_user)
    submission = Repo.get!(Submission, submission_id) |> Repo.preload([:user, :comments])
    changeset = submission
      |> build_assoc(:comments, user_id: user.id)
      |> Comment.changeset(comment_params)
    case Repo.insert(changeset) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully!")
        |> redirect(to: user_submission_path(conn, :show, submission.user, submission))
      {:error, changeset} ->
        render(conn, Jod.SubmissionView, "show.html", submission: submission, user: submission.user, comment_changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "submission_id" => submission_id, "comment" => comment_params}) do
    submission = Repo.get!(Submission, submission_id) |> Repo.preload(:user)
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: user_submission_path(conn, :show, submission.user, submission))
      {:error, _} ->
        conn
        |> put_flash(:info, "Failed to update comment!")
        |> redirect(to: user_submission_path(conn, :show, submission.user, submission))
    end
  end
  
  def delete(conn, %{"id" => id, "submission_id" => submission_id}) do
    submission = Repo.get!(Submission, submission_id) |> Repo.preload(:user)
    Repo.get!(Comment, id) |> Repo.delete!
    conn
    |> put_flash(:info, "Deleted comment!")
    |> redirect(to: user_submission_path(conn, :show, submission.user, submission))
  end

  defp set_submission(conn) do
    submission = Repo.get!(Submission, conn.params["submission_id"]) |> Repo.preload(:user)
    assign(conn, :submission, submission)
  end

  defp set_submission_and_authorize_user(conn, _opts) do
    conn = set_submission(conn)
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that comment!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    submission = conn.assigns[:submission]
    user && ((user.id == submission.user_id) || Jod.RoleChecker.is_admin?(user))
  end
end