defmodule Esctg.Accountant do
  require Logger

  alias Esctg.Channel
  alias Esctg.Repo
  alias Esctg.Mastodon

  def maybe_update_info!(req, chan, info) do
    if should_update_info?(chan, info) do
      update_info!(req, chan, info)
      true
    else
      false
    end
  end

  defp update_info!(req, %Channel{} = chan, info) do
    Logger.notice("updating info chan=#{chan.url}")

    avatar = Esctg.Http.prepare_multipart!(req, info.image)

    name =
      if String.graphemes(info.title) <= 26 do
        info.title <> "🪞bot"
      else
        String.slice(info.title, 0, 30)
      end

    Mastodon.update_credentials!(req,
      display_name: name,
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
