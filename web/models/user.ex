defmodule Jod.User do
  use Jod.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :username, :string
    field :password_hash, :string

    timestamps()

    #Virtual password fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true 
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :username, :password, :password_confirmation])
    |> validate_required([:first_name, :email, :username, :password, :password_confirmation])
  end
end
