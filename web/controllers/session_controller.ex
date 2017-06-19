defmodule Jod.SessionController do
  use Jod.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => user, 
                                     "password" => pass}}) do
    case Jod.Auth.login_by_email_and_pass(conn, user, pass, repo: Repo) do
      
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Logged In")
        |> redirect(to: page_path(conn, :index))
      
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Please check your credentials")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: page_path(conn, :index))
  end

end