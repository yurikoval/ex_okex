# ExOkex

OKEX API client for Elixir.

[![Build Status](https://travis-ci.com/acuityinnovations/ex_okex.svg?branch=master)](https://travis-ci.com/acuityinnovations/ex_okex)

## Installation

List the Hex package in your application dependencies.

```elixir
def deps do
  [{:ex_okex, "~> 0.1"}]
end
```

Run `mix deps.get` to install.

## Configuration

### Static API Key

Static API Key is the key you setup once and would never change. And this is what we need for most cases.

Add the following configuration variables in your config/config.exs file:

```elixir
use Mix.Config

config :ex_okex, api_key:        {:system, "OKEX_API_KEY"},
                 api_secret:     {:system, "OKEX_API_SECRET"},
                 api_passphrase: {:system, "OKEX_API_PASSPHRASE"}
```

Alternatively to hard coding credentials, the recommended approach is
to use environment variables as follows:

```elixir
use Mix.Config

config :ex_okex, api_key:        System.get_env("OKEX_API_KEY"),
                 api_secret:     System.get_env("OKEX_API_SECRET"),
                 api_passphrase: System.get_env("OKEX_API_PASSPHRASE")
```

If you're using websocket then you need to do this config

```elixir
use Mix.Config

config :ex_okex, api_key:        System.get_env("OKEX_API_KEY"),
                 api_secret:     System.get_env("OKEX_API_SECRET"),
                 api_passphrase: System.get_env("OKEX_API_PASSPHRASE"),
                 ping_interval:  System.get_env("OKEX_PING_INTERVAL") # default is 5000
```


Alternatively, if you need to work with multiple OKEX accounts, the private API
call functions accept an additional `config` (`ExOkex.Config` struct) parameter:

```elixir
config = %ExOkex.Config{
  api_key: "API_KEY",
  api_secret: "API_SECRET",
  api_passphrase: "API_PASSPHRASE",
  api_url: "API_URL" # optional
}
ExOkex.list_accounts() # use config as specified in config.exs
ExOkex.list_accounts(config) # use the passed config struct param
```

### Dynamic API Key

There will be cases when we want to switch to different API keys based on different info or need. That's why we're supporting this.

One of the use case when you want to have the dynamic API key feature is: when you want to using multiple API keys in the same app. In that case you simply need to spawn a process which encapsulate the config info. And each process with have it's own credentials to interact with Okex.

So we can tell either API or Websocket module to use certain access keys to retrieve the API keys that we want.

*NOTE*: The access key must be in string.

*SECURITY*: Access key is passed around instead of actual value of the key is to reduce the security risk. People can not inspect the key when the program up and running. This follow Tell, don't ask principle.

#### Websocket

During the setup you can pass the access keys as argument. Ex:

```elixir
defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExOkex.Ws
end

WsWrapper.start_link(%{
  channels: ["futures/trade:BTC-USD-190904"],
  require_auth: true,
  config: %{access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]}
})

WsWrapper.start_link(%{
  channels: ["futures/trade:BTC-USD-190904"],
  require_auth: true,
  config: %{access_keys: ["OK_2_API_KEY", "OK_2_API_SECRET", "OK_2_API_PASSPHRASE"]}
})
```

Then Websocket will use the above access_keys to get the key value from the environment variables.

#### API

Simply pass the config to the API call

Example:

```elixir
config = %{access_keys: ["OK_1_API_KEY", "OK_1_API_SECRET", "OK_1_API_PASSPHRASE"]}

ExOkex.Futures.create_bulk_orders(
  [
    %{
      "instrument_id":"BTC-USD-180213",
      "type":"1",
      "price":"432.11",
      "size":"2",
      "match_price":"0",
      "leverage":"10"
    },
  ],
  config
)
```

## Usage

Place a limit order

```elixir
iex> ExOkex.create_order(%{
  "client_oid" => "20180728",
  "instrument_id" => "btc-usdt",
  "side" => "sell",
  "type" => "limit",
  "size" => "0.1",
  "price" => "1",
  "margin_trading" => 1
})
{:ok,
 %{"order_id" => "234652",
   "client_oid" => "23",
   "result" => true}
```

## Websocket

You can subscrube to private and public Okex feeds by adding this to your application.ex, and creating a handler:

```elixir
worker(OkexWebSocketHandler, [
  %{
    channels: [
      "ok_sub_futureusd_trades",
      "ok_sub_futureusd_userinfo",
      "ok_sub_futureusd_positions"
    ],
    require_auth: true
  }
])
```

```elixir
defmodule OkexWebSocketHandler do
  use ExOkex.Ws

  def handle_response(resp, _state) do
    IO.inspect(resp)
    {:ok, resp}
  end
end
```

## Additional Links

[Full Documentation](https://hexdocs.pm/ex_okex/ExOkex.html)

[OKEX API Docs](https://www.okex.com/docs/)

## License

MIT

## Acknowledgement

Many parts of this client were taken from [ExGdax](https://github.com/bnhansn/ex_gdax) and adapted for OKEx API.
