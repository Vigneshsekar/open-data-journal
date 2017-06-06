defmodule Jod.User do
  use Jod.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name, :email])
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6)
    |> generate_password_hash()
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

        _ ->
          changeset
    end
  end
end
