defmodule Jod.UserController do
  use Jod.Web, :controller
  alias Jod.User

  #:scrub_params function plug to convert blank-string params into nils
  plug :scrub_params, "user" when action in ~w(create)a

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} -> 
        conn
        |> Jod.Auth.login(user) #Sign-in user on account creation
        |> put_flash(:info, "Welcome #{user.name}!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} -> 
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        conn
        |> render("show.html", user: user, changeset: changeset)
      :error ->
        conn
        |> put_flash(:info, "Access denied!")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.registration_changeset(user, user_params)
    cond do
      user == Guardian.Plug.current_resource(conn) ->
        case Repo.update(changeset) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "You information has been updated, #{user.name}")
            |> redirect(to: user_path(conn, :index))
            
          {:error, changeset} ->
            conn
            |> render("show.html", user: user, changeset: changeset)
        end
      :error ->
        conn
        |> put_flash(:info, "No access")
        |> redirect(to: page_path(conn, :index))
    end
  end
  
end