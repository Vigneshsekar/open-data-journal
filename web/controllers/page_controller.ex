defmodule Jod.PageController do
  use Jod.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
