defmodule Jod.Router do
  use Jod.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Jod.CurrentUser
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: Jod.GuardianErrorHandler
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin_auth do
    plug Jod.CheckAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Jod do
    # Login not required for accessing this section
    pipe_through [:browser, :with_session] 

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    # Login required to access the below.
    scope "/", Jod do
      pipe_through [:browser_auth]

      resources "/users", UserController, only: [:show, :index, :update]
      resources "/submissions", SubmissionController

      # Admin zone
      scope "/admin", Admin, as: :admin do
        pipe_through [:admin_auth]

        resources "/users", UserController, only: [:index, :show] do
          resources "/submissions", SubmissionController, only: [:index, :show]
        end
      end  
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jod do
  #   pipe_through :api
  # end
end
