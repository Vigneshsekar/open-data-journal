defmodule Jod.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :title, :string
      add :metadata, :map
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:submissions, [:user_id])

  end
end
