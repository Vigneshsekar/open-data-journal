defmodule Jod.SubmissionController do
  use Jod.Web, :controller

  alias Jod.Submission

  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
  plug :set_authorization_flag

  def index(conn, _params) do
    submissions = Repo.all(assoc(conn.assigns[:user], :submissions))
    render(conn, "index.html", submissions: submissions)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:submissions)
      |> Submission.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"submission" => submission_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:submissions)
      |> Submission.changeset(submission_params)

    case Repo.insert(changeset) do
      {:ok, _submission} ->
        conn
        |> put_flash(:info, "You submission has been made successfully.")
        |> redirect(to: user_submission_path(conn, :index, conn.assigns[:user]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    submission = Repo.get!(assoc(conn.assigns[:user], :submissions), id)
    |> Repo.preload(:comments)
    
    comment_changeset = submission
      |> build_assoc(:comments)
      |> Jod.Comment.changeset()
    render(conn, "show.html", submission: submission, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    submission = Repo.get!(assoc(conn.assigns[:user], :submissions), id)
    changeset = Submission.changeset(submission)
    render(conn, "edit.html", submission: submission, changeset: changeset)
  end

  def update(conn, %{"id" => id, "submission" => submission_params}) do
    submission = Repo.get!(assoc(conn.assigns[:user], :submissions), id)
    changeset = Submission.changeset(submission, submission_params)

    case Repo.update(changeset) do
      {:ok, submission} ->
        conn
        |> put_flash(:info, "Your submission has been updated successfully.")
        |> redirect(to: user_submission_path(conn, :show, conn.assigns[:user], submission))
      {:error, changeset} ->
        render(conn, "edit.html", submission: submission, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    submission = Repo.get!(assoc(conn.assigns[:user], :submissions), id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(submission)
    conn
    |> put_flash(:info, "Your submission has been deleted successfully.")
    |> redirect(to: user_submission_path(conn, :index, conn.assigns[:user]))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(Jod.User, user_id) do
          nil  -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end
      _ -> invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    (user && (Integer.to_string(user.id) == conn.params["user_id"] || Jod.RoleChecker.is_admin?(user)))
  end

  defp authorize_user(conn, _opts) do
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify it!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp set_authorization_flag(conn, _opts) do
    assign(conn, :author_or_admin, is_authorized_user?(conn))
  end
end
