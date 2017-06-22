defmodule Jod.User do
  use Jod.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

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

    has_many :submissions, Jod.Submission
    belongs_to :role, Jod.Role
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :username, :password, :password_confirmation, :role_id])
    |> validate_required([:first_name, :email, :username, :password, :password_confirmation, :role_id])
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_hash, hashpwsalt(password))
    else
      changeset
    end
  end
end
