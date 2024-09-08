defmodule Esctg.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:url, :string, size: 255, null: false)
      add(:title, :string, size: 255, null: false)
      add(:image, :string, size: 255, null: false)
      add(:description, :string, size: 255, null: false)

      add(:api_token, :string, size: 255, null: false)
      add(:api_url, :string, size: 255, null: false)
      add(:enabled, :boolean, null: false)

      timestamps()
    end

    create(unique_index(:channels, [:url, :enabled]))
  end
end
