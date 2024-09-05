defmodule Esctg.Poster do
  alias Esctg.Mastodon

  def post!(chan, msgs) do
    req = Mastodon.new(chan.api_url, chan.api_token)
    Enum.each(msgs, fn msg -> post_msg!(req, msg) end)
  end

  defp post_msg!(req, msg) do
    media_ids =
      msg.media
      |> Enum.map(fn url -> upload_media!(req, url) end)
      |> Enum.reduce([], fn id, acc -> Keyword.put(acc, :"media_ids[]", id) end)

    Mastodon.post_status!(
      req,
      Keyword.merge(
        [
          status: "",
          visibility: "public"
        ],
        media_ids
      )
    )
  end

  defp upload_media!(req, url) do
    %{status: 200, body: media_binary, headers: %{"content-type" => content_type}} = Req.get!(url)
    file = {media_binary, content_type: content_type, filename: url}

    %{id: id} = Mastodon.upload_media!(req, file)
    id
  end
end
