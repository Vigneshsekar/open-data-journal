defmodule Jod.Router do
  use Jod.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Jod do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/submissions", SubmissionController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jod do
  #   pipe_through :api
  # end
end
