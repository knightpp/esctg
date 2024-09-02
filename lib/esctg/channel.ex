defmodule Esctg.Channel do
  use Ecto.Schema

  schema "channels" do
    field(:url, :string)
    field(:name, :string)
  end
end
