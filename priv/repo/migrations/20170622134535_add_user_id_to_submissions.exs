defmodule Jod.Repo.Migrations.AddUserIdToSubmissions do
  use Ecto.Migration

  def change do
    alter table(:submissions) do
      add :user_id, references(:users)
    end
    create index(:submissions, [:user_id])
  end
end
