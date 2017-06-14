defmodule Jod.RoleChecker do
  alias Jod.Repo
  alias Jod.Role

  def is_admin?(user) do
    if (Repo.get(Role, user.role_id) == 1), do: :true, else: :false
  end

  def is_editor?(user) do
    if (Repo.get(Role, user.role_id) == 2), do: :true, else: :false
  end
end