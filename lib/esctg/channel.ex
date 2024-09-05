defmodule Esctg.Channel do
  use Ecto.Schema

  schema "channels" do
    field(:url, :string)
    field(:title, :string)
    field(:image, :string)
    field(:description, :string)
    field(:api_token, :string)
    field(:api_url, :string)
    field(:enabled, :boolean)
  end
end
