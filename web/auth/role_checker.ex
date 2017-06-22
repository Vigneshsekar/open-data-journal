defmodule Jod.RoleChecker do
  alias Jod.Repo
  alias Jod.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end