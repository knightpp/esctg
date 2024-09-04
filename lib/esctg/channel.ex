defmodule Esctg.Channel do
  use Ecto.Schema

  schema "channels" do
    field(:url, :string)
    field(:title, :string)
    field(:image, :string)
    field(:description, :string)
    field(:mastodon_token, :string)
    field(:enabled, :boolean)
  end
end
