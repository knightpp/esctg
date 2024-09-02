defmodule Esctg.Repo.Migrations.CreateSeen do
  use Ecto.Migration

  def change do
    create table(:seens) do
      add(:post_id, :integer, null: false)
      add(:channel_id, references("channels"), null: false)
    end
  end
end
