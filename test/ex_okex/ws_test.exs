defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExOkex.Ws
end

defmodule ExOkex.WsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  setup do
    channels = ["futures/trade:BTC-USD-190904"]

    {:ok, socket} =
      WsWrapper.start_link(%{
        channels: channels,
        require_auth: false,
        config: %{access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]}
      })

    {:ok, socket: socket, state: :sys.get_state(socket)}
  end

  describe "initial state" do
    test "get state", %{state: state} do
      assert state == %{
               channels: ["futures/trade:BTC-USD-190904"],
               config: %{
                 access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]
               },
               heartbeat: 0,
               require_auth: false
             }
    end

    test "pong response from okex", %{state: state} do
      data = {:binary, <<43, 200, 207, 75, 7, 0>>}

      assert capture_log(fn -> WsWrapper.handle_frame(data, state) end) =~
               "received response: \"pong\""
    end
  end

  describe "logging" do
    test "it logs connect", %{state: state} do
      assert capture_log(fn -> WsWrapper.handle_connect(%{}, state) end) =~ "OKEX Connected!"
    end

    test "it logs disconnect", %{state: state} do
      assert capture_log(fn -> WsWrapper.handle_disconnect(%{}, state) end) =~
               "OKEX Disconnected!"
    end
  end
end
