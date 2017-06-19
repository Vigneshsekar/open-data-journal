defmodule Jod.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, :access)
  end

  def login_by_email_and_pass(conn, email, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Jod.User, email: email)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthenticated, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end