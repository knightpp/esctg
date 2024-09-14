defmodule Esctg.AccountantTest do
  use ExUnit.Case

  alias Esctg.Repo
  alias Esctg.Channel
  alias Esctg.Accountant

  @moduletag capture_log: true

  setup do
    :ok = Ecto.Migrator.up(Repo, 20_240_901_100_155, Repo.Migrations.CreateSeen, all: true)
    :ok = Ecto.Migrator.up(Repo, 20_240_901_100_434, Repo.Migrations.CreateChannels, all: true)

    on_exit(fn ->
      Ecto.Migrator.down(Repo, 20_240_901_100_155, Repo.Migrations.CreateSeen)
      Ecto.Migrator.down(Repo, 20_240_901_100_434, Repo.Migrations.CreateChannels)
    end)

    Req.Test.verify_on_exit!()
  end

  test "should update channel info" do
    Req.Test.expect(Accountant, &Req.Test.text(&1, "not an image"))

    Req.Test.expect(Accountant, fn conn ->
      assert conn.method == "PATCH"
      assert conn.request_path == "/api/v1/accounts/update_credentials"
      assert {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert String.contains?(body, "new title")
      assert String.contains?(body, "new test descr")
      assert String.contains?(body, "not an image")
      Req.Test.json(conn, %{})
    end)

    req = Req.new(plug: {Req.Test, Accountant})

    chan = Channel.insert_new!("https://plugged", "token", "api_url")

    Accountant.maybe_update_info!(req, chan, %{
      title: "new title",
      image: "https://test-image.url",
      description: "new test descr"
    })
  end
end
