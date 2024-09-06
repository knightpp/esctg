defmodule Esctg.Scanner do
  import Ecto.Query, only: [from: 2]

  alias Esctg.Repo
  alias Esctg.Channel
  alias Esctg.Seen

  def scan!(url) do
    %{status: 200, body: body} = Req.get!(url)
    Esctg.Parser.parse!(body)
  end

  def scan_new!(%Channel{} = chan) do
    info = scan!(chan.url)

    max_id =
      Repo.one!(from(s in Seen, where: s.channel_id == ^chan.id, select: max(s.post_id)))

    messages =
      info.latest.messages
      |> Enum.filter(fn msg -> msg.id > max_id end)

    %{info | messages: messages}
  end
end
