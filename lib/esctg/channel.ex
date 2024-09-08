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
    chan
    |> Ecto.Changeset.cast(params, [
      :url,
      :title,
      :image,
      :description,
      :api_token,
      :api_url,
      :enabled
    ])
    |> Ecto.Changeset.validate_required([
      :url,
      :title,
      :api_token,
      :api_url,
      :enabled
    ])
    |> Ecto.Changeset.unique_constraint(:url)
  end

  def create_new!(%{url: url, api_token: api_token, api_url: api_url}) do
    chan =
      %Esctg.Channel{
        url: url,
        api_token: api_token,
        api_url: api_url,
        title: "",
        image: "",
        description: "",
        enabled: true
      }
      |> changeset()
      |> Esctg.Repo.insert!()

    Esctg.Scheduler.Supervisor.start_child(chan)
  end
end
