defmodule Esctg.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:url, :string, size: 255, null: false)
      add(:title, :string, size: 255, null: false)
      add(:image, :string, size: 255, null: false)
      add(:description, :string, size: 255, null: false)
      add(:mastodon_token, :string, size: 255, null: false)
      add(:enabled, :boolean, null: false)
    end
  end
end
