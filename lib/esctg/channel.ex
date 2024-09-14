defmodule Esctg.Channel do
  use Ecto.Schema
  require Logger

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
    Logger.notice("start new channel scheduler url=#{arg.url}")

    chan = insert_new!(arg.url, arg.api_token, arg.api_url)
    Esctg.Scheduler.Supervisor.start_child(chan)
  end

  def insert_new!(url, api_token, api_url) do
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
