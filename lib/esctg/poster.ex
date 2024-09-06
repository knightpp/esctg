defmodule Esctg.Poster do
  require Logger

  import Ecto.Query, only: [from: 2]

  alias Esctg.Mastodon
  alias Esctg.Repo
  alias Esctg.Seen

  def post!(chan, msgs) do
    req = Mastodon.new(chan.api_url, chan.api_token)

    Enum.each(msgs, fn msg ->
      q = from(s in Seen, where: s.post_id == ^msg.id and s.channel_id == ^chan.id)

      if not Repo.exists?(q) do
        post_msg!(req, msg)
        Repo.insert!(%Seen{post_id: msg.id, channel_id: chan.id})
      end
    end)
  end

  defp post_msg!(req, msg) do
    Logger.info("posting msg id=#{msg.id}")

    # TODO: support more than 4 media
    media_ids =
      msg.media
      |> Stream.take(4)
      |> Enum.map(fn url -> upload_media!(req, url) end)
      |> Enum.reduce([], fn id, acc -> Keyword.put(acc, :"media_ids[]", id) end)

    Mastodon.post_status!(
      req,
      Keyword.merge(
        [
          status: limit_string(msg.text, 500),
          visibility: "public"
        ],
        media_ids
      )
    )
  end

  defp upload_media!(req, url) do
    file = Esctg.Http.prepare_multipart!(url)
    %{"id" => id} = Mastodon.upload_media!(req, file: file)
    id
  end

  defp limit_string(str, max) when max > 1 do
    if String.length(str) <= max do
      str
    else
      str |> String.slice(0, max - 1) |> Kernel.<>("…")
    end
  end
end
