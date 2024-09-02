defmodule Esctg.Seen do
  use Ecto.Schema

  schema "seens" do
    field(:post_id, :integer)
    belongs_to(:channel, Esctg.Channel)
  end
end
