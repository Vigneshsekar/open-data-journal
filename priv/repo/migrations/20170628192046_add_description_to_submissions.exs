defmodule Jod.Repo.Migrations.AddDescriptionToSubmissions do
  use Ecto.Migration

  def change do
    alter table(:submissions) do
      add :description, :string
    end
  end
end
