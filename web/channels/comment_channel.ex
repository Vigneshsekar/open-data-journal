defmodule Jod.CommentChannel do
  use Jod.Web, :channel

  def join("comments:" <> _comment_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comment:lobby).
  def handle_in("CREATED_COMMENT", payload, socket) do
    broadcast socket, "CREATED_COMMENT", payload
    {:noreply, socket}
  end

  def handle_in("DELETED_COMMENT", payload, socket) do
    broadcast socket, "DELETED_COMMENT", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
