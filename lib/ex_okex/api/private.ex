defmodule ExOkex.Api.Private do
  @moduledoc """
  Interface for authenticated HTTP requests
  """

  import ExOkex.Api
  alias ExOkex.Config

  def get(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)
    qs = query_string(path, params)

    qs
    |> url(config)
    |> HTTPoison.get(headers("GET", qs, %{}, config))
    |> parse_response()
  end

  def post(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.post(Jason.encode!(params), headers("POST", path, params, config))
    |> parse_response()
  end

  def delete(path, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.delete(headers("DELETE", path, %{}, config))
    |> parse_response()
  end

  defp headers(method, path, body, config) do
    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:millisecond)
      |> DateTime.to_iso8601(:extended)

    [
      "Content-Type": "application/json",
      "OK-ACCESS-KEY": config.api_key,
      "OK-ACCESS-SIGN": sign_request(timestamp, method, path, body, config),
      "OK-ACCESS-TIMESTAMP": timestamp,
      "OK-ACCESS-PASSPHRASE": config.api_passphrase
    ]
  end

  defp sign_request(timestamp, method, path, body, config) do
    key = config.api_secret || ""
    body = if Enum.empty?(body), do: "", else: Jason.encode!(body)
    data = "#{timestamp}#{method}#{path}#{body}"

    :sha256
    |> :crypto.hmac(key, data)
    |> Base.encode64()
  end
end
