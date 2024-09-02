defmodule Esctg.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add(:id, :integer)
      add(:name, :string)
    end
  end
end
