defmodule Jod.Token do
  use Jod.Web, :controller
  
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