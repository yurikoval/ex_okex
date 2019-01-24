defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExOkex.Ws
end

defmodule ExOkex.WsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  setup do
    channels = ["futures/trade:BTC-USD-190904"]

    {:ok, socket} =
      WsWrapper.start_link(%{
        channels: channels,
        require_auth: false,
        config: %{access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]}
      })

    {:ok, socket: socket}
  end

  describe "initial state" do
    test "get state", %{socket: socket} do
      assert :sys.get_state(socket) == %{
               channels: ["futures/trade:BTC-USD-190904"],
               config: %{
                 access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]
               },
               heartbeat: 0,
               require_auth: false
             }
    end
  end
end
