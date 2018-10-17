use Mix.Config

config :ex_okex,
  api_key: {:system, "OKEX_TEST_API_KEY"},
  # Base.encode64("OKEX_TEST_API_SECRET")
  api_secret: {:system, "R0RBWF9URVNUX0FQSV9TRUNSRVQ="},
  api_passphrase: {:system, "OKEX_TEST_API_PASSPHRASE"},
  api_url: {:system, "https://api-public.sandbox.okex.com"}
