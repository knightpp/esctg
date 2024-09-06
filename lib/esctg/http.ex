defmodule Esctg.Http do
  def prepare_multipart!(url) do
    %{status: 200, body: media_binary, headers: %{"content-type" => content_type}} = Req.get!(url)
    {media_binary, content_type: content_type, filename: url}
  end
end
