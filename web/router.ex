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
    resources "/users", UserController do
      resources "/submissions", SubmissionController
    end
    
    resources "/submissions", SubmissionController, only: [] do
      resources "/comments", CommentController, only: [:create, :delete, :update]
    end
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jod do
  #   pipe_through :api
  # end
end
