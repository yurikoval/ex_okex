use Mix.Config

config :ex_okex,
  api_key: System.get_env("OKEX_API_KEY"),
  api_secret: System.get_env("OKEX_API_SECRET"),
  api_passphrase: System.get_env("OKEX_API_PASSPHRASE")
