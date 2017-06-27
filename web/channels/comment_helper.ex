defmodule Jod.CommentHelper do
  alias Jod.Comment
  alias Jod.Submission
  alias Jod.User
  alias Jod.Repo

  import Ecto, only: [build_assoc: 3]

  def create(%{"submissionId" => submission_id, "body" => body, "author" => author}, %{assigns: %{user: user_id}}) do
    submission      = get_submission(submission_id)
    user = get_user(user_id)
    changeset = submission
      |> build_assoc(:comments, user_id: user.id)
      |> Comment.changeset(%{body: body, author: author})

    Repo.insert(changeset)
  end

  def delete(%{"submissionId" => submission_id, "commentId" => comment_id}, %{assigns: %{user: user_id}}) do
    authorize_and_perform(submission_id, user_id, fn ->
      comment = Repo.get!(Comment, comment_id)
      Repo.delete(comment)
    end)
  end

  def delete(_params, %{}), do: {:error, "User is not authorized"}
  def delete(_params, nil), do: {:error, "User is not authorized"}

  defp authorize_and_perform(submission_id, user_id, action) do
    submission = get_submission(submission_id)
    user = get_user(user_id)
    if is_authorized_user?(user, submission) do
      action.()
    else
      {:error, "User is not authorized"}
    end
  end

  defp get_user(user_id) do
    Repo.get!(User, user_id)
  end

  defp get_submission(submission_id) do
    Repo.get!(Submission, submission_id) |> Repo.preload([:user, :comments])
  end

  defp is_authorized_user?(user, submission) do
    (user && (user.id == submission.user_id || Jod.RoleChecker.is_admin?(user)))
  end
end