defmodule Twitterclone.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :username, :string
      add :body, :string
      add :likes_count, :integer
      add :replies_count, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
