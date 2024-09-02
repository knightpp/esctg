defmodule Esctg.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:url, :string, size: 255, null: false)
      add(:name, :string, size: 255, null: false)
    end
  end
end
