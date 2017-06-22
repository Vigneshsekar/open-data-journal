defmodule Jod.CommentController do
  use Jod.Web, :controller

  alias Jod.Comment
  alias Jod.Submission
  plug :scrub_params, "comment" when action in [:create, :update]

  def create(conn, %{"comment" => comment_params, "submission_id" => submission_id}) do
    submission = Repo.get!(Submission, submission_id) |> Repo.preload([:user, :comments])
    changeset = submission
      |> build_assoc(:comments)
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

  def update(conn, _), do: conn
  def delete(conn, _), do: conn
end