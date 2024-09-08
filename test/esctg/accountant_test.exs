defmodule Esctg.AccountantTest do
  use ExUnit.Case

  alias Esctg.Repo
  alias Esctg.Channel
  alias Esctg.Accountant

  @tg_response File.read!("test/data/daifuku.html")

  setup do
    :ok = Ecto.Migrator.up(Repo, 20_240_901_100_155, Repo.Migrations.CreateSeen, all: true)
    :ok = Ecto.Migrator.up(Repo, 20_240_901_100_434, Repo.Migrations.CreateChannels, all: true)

    on_exit(fn ->
      Ecto.Migrator.down(Repo, 20_240_901_100_155, Repo.Migrations.CreateSeen)
      Ecto.Migrator.down(Repo, 20_240_901_100_434, Repo.Migrations.CreateChannels)
    end)

    Req.Test.verify_on_exit!()
  end

  test "should crash when empty database" do
    assert_raise(Ecto.NoResultsError, fn -> Accountant.maybe_update_info!(nil, "plugged") end)
  end

  test "should crash when empty database2" do
    Req.Test.expect(Accountant, &Req.Test.html(&1, @tg_response))
    req = Req.new(plug: {Req.Test, Accountant})

    chan =
      Esctg.Channel.create_new!(%{url: "https://plugged", api_token: "token", api_url: "api_url"})

    # TODO: scanner does not use passed req
    Accountant.maybe_update_info!(req, "https://plugged")
  end
end
