defmodule Esctg.Repo.Migrations.CreateSeen do
  use Ecto.Migration

  def change do
    create table(:seen) do
      add(:id, :integer)
      add(:channel_id, :integer)
    end
  end
end
