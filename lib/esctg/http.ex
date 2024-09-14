defmodule Esctg.Http do
  def prepare_multipart!(req, url) do
    %{status: 200, body: media_binary, headers: %{"content-type" => content_type}} =
      Req.get!(req, url: url, auth: "")

    {media_binary, content_type: content_type, filename: url}
  end
end
