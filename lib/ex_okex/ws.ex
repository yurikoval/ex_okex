defmodule ExOkex.Ws do
  use WebSockex
  require Logger

  # Client API
  defmacro __using__(_opts) do
    quote do
      def start_link(opts \\ []) do
        WebSockex.start_link(
          "wss://real.okex.com:10440/websocket/okexapi",
          __MODULE__,
          :fake_state,
          opts
        )
      end

      def subscribe(client, channel \\ "index/ticker:BTC-USD") do
        # params = Poison.encode!(%{op: "subscribe", args: ["#{channel}"]})
        channel = "ok_sub_futureusd_btc_index"
        params = Poison.encode!(%{event: "addChannel", channel: channel})
        WebSockex.send_frame(client, {:text, params})
      end

      # V3
      # def login(client) do
      #   params = Poison.encode!(%{op: "login", args: auth_params()})
      #   WebSockex.send_frame(client, {:text, params})
      # end

      # V1
      def login(client) do
        params = Poison.encode!(%{event: "login", parameters: auth_params()})
        WebSockex.send_frame(client, {:text, params})
      end

      def auth_params do
        api_key = Application.get_env("okex_api_key")
        secret_key = Application.get_env("okex_secret_key")
        timestamp = (:os.system_time(:millisecond) / 1000) |> Float.to_string()
        path = "GET/users/self/verify"
        sign_data = "#{timestamp}#{path}"

        sign =
          :sha256
          |> :crypto.hmac(secret_key, sign_data)
          |> Base.encode64()

        %{
          api_key: api_key,
          passphrase: Application.get_env("okex_passphrase"),
          timestamp: timestamp,
          sign: sign
        }
      end

      # Callbacks

      def handle_connect(_conn, state) do
        Logger.info("Connected!")
        {:ok, state}
      end

      def handle_frame({:binary, compressed_data}, :fake_state) do
        compressed_data
        |> :zlib.unzip()
        |> Poison.decode!()
        |> handle_uncompressed_data()
      end

      def handle_uncompressed_data(%{"event" => "login", "success" => true}) do
        Logger.info("Login success!")
        {:ok, :fake_state}
      end

      def handle_uncompressed_data(%{"channel" => "addChannel", "data" => data}) do
        IO.inspect(data)
        {:ok, :fake_state}
      end

      # Sample response data
      # data = %{
      #   "futureIndex" => "3464.6675",
      #   "timestamp" => "1544435154968",
      #   "usdCnyRate" => "6.899"
      # }

      def handle_uncompressed_data(%{"channel" => _channel, "data" => data}) do
        IO.inspect(data)
        {:ok, :fake_state}
      end

      def handle_uncompressed_data([data]) do
        handle_uncompressed_data(data)
      end

      def handle_uncompressed_data(%{"channel" => "login", "data" => data}) do
        Logger.info("Login success!")
        {:ok, :fake_state}
      end

      def handle_uncompressed_data(%{"event" => "subscribe", "subscribe" => channel}) do
        Logger.info("You're subcribing this channel #{channel}")
        {:ok, :fake_state}
      end

      def handle_uncompressed_data(%{"table" => table, "data" => data}) do
        IO.inspect(data)
        {:ok, :fake_state}
      end

      def handle_disconnect(_params, _state) do
        Logger.info("something went wrong")
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
