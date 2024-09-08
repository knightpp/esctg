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

  def start_new!(arg) do
    chan = create_new!(arg)
    Esctg.Scheduler.Supervisor.start_child(chan)
  end

  def create_new!(%{url: url, api_token: api_token, api_url: api_url}) do
    %Esctg.Channel{
      url: url,
      api_token: api_token,
      api_url: api_url,
      title: "temporary",
      image: "",
      description: "",
      enabled: true
    }
    |> changeset()
    |> Esctg.Repo.insert!()
  end
end
