defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExOkex.Ws
end

defmodule ExOkex.WsTest do
  @moduledoc false

  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  setup do
    args = %{
      channels: ["futures/trade:BTC-USD-190904"],
      config: %{access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]},
      require_auth: false
    }

    {:ok, args: args, state: Map.put(args, :heartbeat, 0)}
  end

  describe "start_link" do
    test "starts a supervised WebSockex process offline", %{args: args, state: state} do
      endpoint = start_websocket_server()
      previous_endpoint = Application.get_env(:ex_okex, :ws_endpoint)
      Application.put_env(:ex_okex, :ws_endpoint, endpoint)

      on_exit(fn ->
        if previous_endpoint do
          Application.put_env(:ex_okex, :ws_endpoint, previous_endpoint)
        else
          Application.delete_env(:ex_okex, :ws_endpoint)
        end
      end)

      socket = start_supervised!({WsWrapper, args})

      assert Process.whereis(WsWrapper) == socket
      assert :sys.get_state(socket) == state
      assert_receive {:websocket_request, _request}, 1_000
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

  defp start_websocket_server do
    {:ok, listener} =
      :gen_tcp.listen(0, [:binary, ip: {127, 0, 0, 1}, active: false, reuseaddr: true])

    {:ok, {{127, 0, 0, 1}, port}} = :inet.sockname(listener)

    parent = self()

    server =
      spawn(fn ->
        {:ok, socket} = :gen_tcp.accept(listener)
        request = recv_headers(socket, "")
        [_, key] = Regex.run(~r/sec-websocket-key:\s*(.+)\r\n/i, request)

        accept =
          :crypto.hash(:sha, String.trim(key) <> "258EAFA5-E914-47DA-95CA-C5AB0DC85B11")
          |> Base.encode64()

        :ok =
          :gen_tcp.send(
            socket,
            "HTTP/1.1 101 Switching Protocols\r\n" <>
              "Upgrade: websocket\r\n" <>
              "Connection: Upgrade\r\n" <>
              "Sec-WebSocket-Accept: #{accept}\r\n\r\n"
          )

        send(parent, {:websocket_request, request})

        receive do
          :stop -> :gen_tcp.close(socket)
        end
      end)

    on_exit(fn ->
      :gen_tcp.close(listener)
      send(server, :stop)
    end)

    "ws://127.0.0.1:#{port}"
  end

  defp recv_headers(socket, acc) do
    if String.contains?(acc, "\r\n\r\n") do
      acc
    else
      {:ok, data} = :gen_tcp.recv(socket, 0, 1_000)
      recv_headers(socket, acc <> data)
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
