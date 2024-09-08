defmodule Esctg.Seen do
  use Ecto.Schema

  schema "seens" do
    field(:post_id, :integer)
    belongs_to(:channel, Esctg.Channel)
  end

  def changeset(seen, params \\ %{}) do
    seen
    |> Ecto.Changeset.cast(params, [:post_id, :channel_id])
    |> Ecto.Changeset.validate_required([:post_id, :channel_id])
    |> Ecto.Changeset.unique_constraint([:post_id, :channel_id])
  end
end
