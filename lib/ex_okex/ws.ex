defmodule ExOkex.Ws do
  @moduledoc false

  use WebSockex
  import Logger, only: [info: 1]

  # Client API
  defmacro __using__(_opts) do
    quote do
      @base "wss://real.okex.com:10440/websocket/okexapi"
      @ping_interval Application.get_env(:ex_okex, :ping_interval, 5_000)

      def start_link(args \\ %{}) do
        WebSockex.start_link(@base, __MODULE__, args, name: __MODULE__)
      end

      # V1
      def login(server) do
        params = Poison.encode!(%{event: "login", parameters: auth_params()})
        send(server, {:ws_reply, {:text, params}})
      end

      # Callbacks

      def handle_connect(_conn, state) do
        info("OKEX Connected!")
        send(self(), :ws_subscribe)
        {:ok, state}
      end

      def handle_info(:ws_subscribe, %{channel: channel} = state) do
        subscribe(self(), channel)
        {:ok, state}
      end

      def handle_info({:ws_reply, frame}, state) do
        {:reply, frame, state}
      end

      def handle_frame({:binary, compressed_data}, state) do
        compressed_data
        |> :zlib.unzip()
        |> Poison.decode!()
        |> handle_response(state)
      end

      def handle_response([resp], state) do
        info("#{__MODULE__} received response: #{inspect(resp)}")
        handle_response(resp, state)
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

      defoverridable Module.definitions_in(__MODULE__)
    end
  end
end
