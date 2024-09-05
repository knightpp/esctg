defmodule Esctg.Parser do
  def parse!(html) do
    doc = Floki.parse_document!(html)
    [title] = Floki.attribute(doc, "meta[property='og:title'][content]", "content")
    [image] = Floki.attribute(doc, "meta[property='og:image'][content]", "content")
    [description] = Floki.attribute(doc, "meta[property='og:description'][content]", "content")
    msgs = Floki.find(doc, "body main .tgme_widget_message") |> Enum.map(&parse_message!/1)

    %{
      title: title,
      image: image,
      description: description,
      messages: msgs
    }
  end

  defp parse_message!(msg) do
    text =
      msg
      |> Floki.find("div.tgme_widget_message_text")
      |> Enum.take(-1)
      |> Floki.text()

    [datetime] = Floki.attribute(msg, "time", "datetime")
    {:ok, datetime, _} = DateTime.from_iso8601(datetime)

    %{
      id: parse_id!(msg),
      text: text,
      media: parse_media!(msg),
      datetime: datetime
    }
  end

  defp parse_id!(msg) do
    [id] = Floki.attribute(msg, "div.tgme_widget_message", "data-post")

    case :binary.split(id, "/") do
      [_, id] ->
        {id, _} = Integer.parse(id)
        id
    end
  end

  defp parse_media!(msg) do
    # in case of multiple images it will return them all
    msg
    |> Floki.attribute("a.tgme_widget_message_photo_wrap", "style")
    |> Enum.map(&parse_background_image/1)
  end

  # @pattern :binary.compile_pattern(["\n", ";"])
  defp parse_background_image(style) do
    list =
      String.splitter(style, ["\n", ";"])
      |> Stream.map(&parse_style_line/1)
      |> Stream.filter(&(&1 != nil))
      |> Stream.filter(fn {key, _value} -> key == "background-image" end)
      |> Stream.map(fn {_key, value} -> parse_css_url(value) end)
      |> Stream.filter(&(&1 != nil))
      |> Enum.take(1)

    case list do
      [url] -> url
      _ -> nil
    end
  end

  defp parse_style_line(line) do
    case :binary.split(line, ":") do
      [key, value] -> {key, value}
      _ -> nil
    end
  end

  defp parse_css_url(url) do
    case Regex.run(~r/url\('(.+)'\)/, url) do
      [_, group] -> group
      _ -> nil
    end
  end

  # defmodule Channel do
  #   @enforce_keys [:title, :image, :description, :messages]
  #   defstruct [:title, :image, :description, :messages]

  #   @type t :: %__MODULE__{
  #           title: String.t(),
  #           image: String.t(),
  #           description: String.t(),
  #           messages: [Esctg.Parser.Message.t()]
  #         }
  # end

  # defmodule Message do
  #   @enforce_keys [:id, :text, :media, :datetime]
  #   defstruct [:id, :text, :media, :datetime]

  #   @type t :: %__MODULE__{
  #           id: String.t(),
  #           text: String.t(),
  #           media: [String.t()],
  #           datetime: DateTime.t()
  #         }
  # end
end
