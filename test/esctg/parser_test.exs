defmodule Esctg.ParserTest do
  use ExUnit.Case, async: true
  alias Esctg.Parser

  @data_daifuku File.read!("test/data/daifuku.html")

  test "daifuku" do
    dbg(Parser.parse!(@data_daifuku))
  end
end
