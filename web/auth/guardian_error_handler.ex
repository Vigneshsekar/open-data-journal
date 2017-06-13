defmodule SimpleAuth.GuardianErrorHandler do
  import Phoenix.Controller
  import Jod.Router.Helpers
  
  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:info, "Please sign-in to access this page")
    |> redirect(to: session_path(conn, :new))
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:info, "Please sign-in to access this page")
    |> redirect(to: session_path(conn, :new))
  end
end