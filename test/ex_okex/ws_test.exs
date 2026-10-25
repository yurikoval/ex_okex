defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExOkex.Ws
end

defmodule ExOkex.WsTest do
  @moduledoc false

  use ExUnit.Case, async: false

  import ExUnit.CaptureLog
  import Mock

  setup do
    state = %{
      channels: ["futures/trade:BTC-USD-190904"],
      config: %{access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]},
      heartbeat: 0,
      require_auth: false
    }

    {:ok, state: state}
  end

  describe "start_link" do
    test "starts WebSockex with the configured state", %{state: state} do
      test_pid = self()

      with_mock WebSockex,
        start_link: fn endpoint, module, socket_state, options ->
          send(test_pid, {:start_link, endpoint, module, socket_state, options})
          {:ok, test_pid}
        end do
        assert {:ok, ^test_pid} = WsWrapper.start_link(state)

        assert_received {:start_link, "wss://real.okex.com:8443/ws/v3", WsWrapper, ^state,
                         [name: WsWrapper]}
      end
    end
  end

  describe "initial state" do
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

  describe "overrides" do
    defmodule WsWrapperOverride do
      @moduledoc false
      require Logger
      use ExOkex.Ws

      def handle_connect(_, _), do: :works
      def handle_disconnect(_, _), do: :works
      def handle_response(_, _), do: :works
    end

    test "it can override" do
      assert :works == WsWrapperOverride.handle_connect(nil, nil)
      assert :works == WsWrapperOverride.handle_disconnect(nil, nil)
      assert :works == WsWrapperOverride.handle_response(nil, nil)
    end
  end
end
