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
    timestamps()
  end

  def changeset(chan, params \\ %{}) do
    fields = [
      :url,
      :title,
      :image,
      :description,
      :api_token,
      :api_url,
      :enabled
    ]

    chan
    |> Ecto.Changeset.cast(params, fields)
    |> Ecto.Changeset.validate_required(fields)
    |> Ecto.Changeset.unique_constraint(:url)
  end
end
