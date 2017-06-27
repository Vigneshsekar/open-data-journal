defmodule Jod.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :author, :string
      add :body, :text
      add :approved, :boolean, default: true
      add :submission_id, references(:submissions, on_delete: :nothing)

      timestamps()
    end
    create index(:comments, [:submission_id])

  end
end
