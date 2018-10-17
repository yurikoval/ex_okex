use Mix.Config

# Read from environment variables
config :ex_okex,
  api_key: System.get_env("OKEX_API_KEY"),
  api_secret: System.get_env("OKEX_API_SECRET"),
  api_passphrase: System.get_env("OKEX_API_PASSPHRASE")

# Or replace "OKEX_*" values to define here in config file
# config :ex_okex, api_key:        {:system, "OKEX_API_KEY"},
#                  api_secret:     {:system, "OKEX_API_SECRET"},
#                  api_passphrase: {:system, "OKEX_API_PASSPHRASE"}
