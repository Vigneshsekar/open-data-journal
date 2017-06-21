defmodule Jod.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :title, :string
      add :state, :string
      add :data_url, :string
      add :doi, :string
      add :metadata, :map
      add :review_issuer_id, :integer
      add :suggested_editor, :integer

      timestamps()
    end

  end
end
