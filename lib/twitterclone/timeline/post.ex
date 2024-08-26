defmodule Twitterclone.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :username, :string
    field :likes_count, :integer, default: 0
    field :replies_count, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :username])
    |> validate_required([:body, :username])
    |> validate_length(:body, min: 2, max: 250)
    |> validate_length(:username, min: 2, max: 20)
  end
end
