defmodule Esctg.ParserTest do
  use ExUnit.Case, async: true
  alias Esctg.Parser

  @data_daifuku File.read!("test/data/daifuku.html")
  @expect_daifuku File.read!("test/data/daifuku.expect")
  @data_ogo File.read!("test/data/ogo.html")
  @expect_ogo File.read!("test/data/ogo.expect")

  test "daifuku" do
    assert Parser.parse!(@data_daifuku) == :erlang.binary_to_term(@expect_daifuku)
  end

  test "ogo" do
    assert Parser.parse!(@data_ogo) == :erlang.binary_to_term(@expect_ogo)
  end
end
