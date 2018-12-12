defmodule ExOkex.Ws do
  @moduledoc false

  use WebSockex
  import Logger, only: [info: 1]

  # Client API
  defmacro __using__(_opts) do
    quote do
      @base "wss://real.okex.com:10440/websocket/okexapi"
      @ping_interval Application.get_env(:ex_okex, :ping_interval, 5_000)

      def start_link(opts \\ []) do
        WebSockex.start_link(@base, __MODULE__, :fake_state, opts)
      end

      def init(_) do
        ping_me(@ping_interval)
        {:ok, :fake_state}
      end

      defp ping_me(interval) do
        WebSockex.send_frame(self(), {:text, Poison.encode!(%{event: "ping"})})
        Process.send_after(self(), :ping_me, interval)
      end

      def handle_info(:schedule, _state) do
        ping_me(@ping_interval)
        {:noreply, :fake_state}
      end

      def subscribe(client, channel \\ "ok_sub_futureusd_btc_index") do
        params = Poison.encode!(%{event: "addChannel", channel: channel})
        WebSockex.send_frame(client, {:text, params})
      end

      # V1
      def login(client) do
        params = Poison.encode!(%{event: "login", parameters: auth_params()})
        WebSockex.send_frame(client, {:text, params})
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

      # Callbacks

      def handle_connect(_conn, state) do
        info("Connected!")
        {:ok, state}
      end

      def handle_frame({:binary, compressed_data}, :fake_state) do
        compressed_data
        |> :zlib.unzip()
        |> Poison.decode!()
        |> handle_response()
      end

      def handle_response([resp]) do
        info("#{__MODULE__} received response: #{inspect(resp)}")
        handle_response(resp)
      end

      def handle_response(resp) do
        info("#{__MODULE__} received response: #{inspect(resp)}")
        {:ok, :fake_state}
      end

      def handle_disconnect(_, state), do: {:ok, state}

      def terminate({:local, :normal}, %{catch_terminate: pid}),
        do: send(pid, :normal_close_terminate)

      def terminate(_, %{catch_terminate: pid}), do: send(pid, :terminate)
      def terminate(_, _), do: :ok
    end
  end
end
