# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jod.Repo.insert!(%Jod.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Jod.Repo
alias Jod.Role
alias Jod.User
role = %Role{}
  |> Role.changeset(%{name: "Admin Role", admin: true})
  |> Repo.insert!
admin = %User{}
  |> User.changeset(%{username: "admin", email: "admin@test.com", password: "qwerty", password_confirmation: "test", role_id: 1, first_name: "admin_test"})
  |> Repo.insert!