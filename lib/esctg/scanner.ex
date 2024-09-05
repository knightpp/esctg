defmodule Esctg.Scanner do
  import Ecto.Query, only: [from: 2]

  alias Esctg.Repo
  alias Esctg.Channel
  alias Esctg.Seen

  @moduledoc """
    This module should be responsible for scanning telegram channels and
    keeping their track in database.
  """

  @doc """
    scan expects a precreated channel. Its description or title might be nil,
    but `url` should be set.
  """
  def scan!(%Channel{} = chan) do
    %{status: 200, body: body} = Req.get!(chan.url)
    Esctg.Parser.parse!(body)
  end

  @doc """
    The same as `scan` but returns only new messages, that haven't been
    seen.
  """
  def scan_new!(%Channel{} = chan) do
    info = scan!(chan.url)

    max_id =
      Repo.one!(from(s in Seen, where: s.channel_id == ^chan.id, select: max(s.post_id)))

    messages =
      info.latest.messages
      |> Enum.filter(fn msg -> msg.id > max_id end)

    %{info | messages: messages}
  end

  def maybe_update_info(%Channel{} = old_chan, info) do
    if should_update_info?(old_chan, info) do
      old_chan
      |> Ecto.Changeset.cast(info, [:title, :image, :description])
      |> Repo.update!()
    end
  end

  defp should_update_info?(old_chan, new_chan) do
    old_chan.title != new_chan.title or
      old_chan.description != new_chan.description or
      old_chan.image != new_chan.image
  end
end
