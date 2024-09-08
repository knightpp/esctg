defmodule Esctg.Accountant do
  import Ecto.Query, only: [from: 2]

  alias Esctg.Channel
  alias Esctg.Repo
  alias Esctg.Scanner
  alias Esctg.Mastodon

  def maybe_update_info!(req, url) do
    chan = Repo.one!(from(c in Channel, where: c.url == ^url))
    info = Scanner.scan!(chan.url)

    if should_update_info?(chan, info) do
      update_info!(req, chan, info)
    end

    %{
      chan: chan,
      info: info
    }
  end

  defp update_info!(req, %Channel{} = chan, info) do
    avatar = Esctg.Http.prepare_multipart!(info.image)

    Mastodon.update_credentials!(req,
      display_name: info.title <> "🪞bot",
      note: info.description,
      bot: "true",
      avatar: avatar,
      discoverable: "true"
      # :"source[language]" # TODO: add new column with lang
    )

    chan
    |> Ecto.Changeset.cast(info, [:title, :image, :description])
    |> Repo.update!()
  end

  defp should_update_info?(old_chan, new_chan) do
    old_chan.title != new_chan.title or
      old_chan.description != new_chan.description or
      old_chan.image != new_chan.image
  end
end
