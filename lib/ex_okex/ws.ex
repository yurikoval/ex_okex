defmodule ExOkex.Ws do
  @moduledoc false

  import Logger, only: [info: 1, warn: 1]
  import Process, only: [send_after: 3]

  # Client API
  defmacro __using__(_opts) do
    quote do
      use WebSockex
      @base "wss://real.okex.com:10440/websocket/okexapi"
      @ping_interval Application.get_env(:ex_okex, :ping_interval, 5_000)

      def start_link(args \\ %{}) do
        state = Map.merge(args, %{heartbeat: 0})
        WebSockex.start_link(@base, __MODULE__, state, name: __MODULE__)
      end

      # Callbacks

      def handle_pong(:pong, state) do
        {:ok, inc_heartbeat(state)}
      end

      def handle_connect(_conn, state) do
        info("OKEX Connected!")
        send(self(), :ws_subscribe)
        {:ok, state}
      end

      def handle_info(:ws_subscribe, %{channels: channels, require_auth: require_auth} = state) do
        if require_auth == true do
          login(self())
        end

        Enum.each(channels, fn channel -> subscribe(self(), channel) end)

        send_after(self(), {:heartbeat, :ping, 1}, 20_000)
        {:ok, state}
      end

      def handle_info({:ws_reply, frame}, state) do
        {:reply, frame, state}
      end

      def handle_info(
            {:heartbeat, :ping, expected_heartbeat},
            %{heartbeat: heartbeat} = state
          ) do
        if heartbeat >= expected_heartbeat do
          send_after(self(), {:heartbeat, :ping, heartbeat + 1}, 1_000)
          {:ok, state}
        else
          send_after(self(), {:heartbeat, :pong, heartbeat + 1}, 4_000)
          {:reply, {:text, Poison.decode!(%{event: "ping"})}, state}
        end
      end

      def handle_info(
            {:heartbeat, :pong, expected_heartbeat},
            %{heartbeat: heartbeat} = state
          ) do
        if heartbeat >= expected_heartbeat do
          send_after(self(), {:heartbeat, :ping, heartbeat + 1}, 1_000)
          {:ok, state}
        else
          warn("#{__MODULE__} terminated due to " <> "no heartbeat ##{heartbeat}")
          {:close, state}
        end
      end

      def handle_frame({:binary, compressed_data}, state) do
        compressed_data
        |> :zlib.unzip()
        |> Poison.decode!()
        |> handle_response(state)
      end

      def handle_response(resp, state) do
        info("#{__MODULE__} received response: #{inspect(resp)}")
        {:ok, state}
      end

      def handle_disconnect(_, state), do: {:ok, state}

      def terminate({:local, :normal}, %{catch_terminate: pid}),
        do: send(pid, :normal_close_terminate)

      def terminate(_, %{catch_terminate: pid}), do: send(pid, :terminate)
      def terminate(_, _), do: :ok

      # Helpers

      def subscribe(server, channel) do
        params = Poison.encode!(%{event: "addChannel", channel: channel})
        send(server, {:ws_reply, {:text, params}})
      end

      def login(server) do
        params = Poison.encode!(%{event: "login", parameters: auth_params()})
        send(server, {:ws_reply, {:text, params}})
      end

      def auth_params do
        api_key = Application.get_env(:ex_okex, :api_key)
        secret_key = Application.get_env(:ex_okex, :api_secret)
        timestamp = Float.to_string(:os.system_time(:millisecond) / 1000)
        path = "GET/users/self/verify"
        sign_data = "#{timestamp}#{path}"

        sign =
          :sha256
          |> :crypto.hmac(secret_key, sign_data)
          |> Base.encode64()

        %{
          api_key: api_key,
          passphrase: Application.get_env(:ex_okex, :api_passphrase),
          timestamp: timestamp,
          sign: sign
        }
      end

      defp inc_heartbeat(%{heartbeat: heartbeat} = state) do
        Map.put(state, :heartbeat, heartbeat + 1)
      end

      defoverridable handle_response: 2
    end
  end
end
