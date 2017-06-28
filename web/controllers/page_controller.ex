defmodule Jod.PageController do
  use Jod.Web, :controller
  alias Jod.Submission

  def index(conn, _params) do
    submissions = Repo.all(from p in Submission,
                      limit: 5,
                      order_by: [desc: :inserted_at],
                      preload: [:user])
    render(conn, "index.html", submissions: submissions)
  end
end
