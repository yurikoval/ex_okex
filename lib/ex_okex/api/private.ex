defmodule ExOkex.Api.Private do
  @moduledoc """
  Interface for authenticated HTTP requests
  """

  import ExOkex.Api
  alias ExOkex.Config

  @type path :: String.t()
  @type params :: map | [map]
  @type config :: ExOkex.Config.t()
  @type response :: ExOkex.Api.response()

  @spec get(path, params, config | nil) :: response
  def get(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)
    qs = query_string(path, params)

    qs
    |> url(config)
    |> HTTPoison.get(headers("GET", qs, %{}, config))
    |> parse_response()
  end

  @spec post(path, params, config | nil) :: response
  def post(path, params \\ %{}, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.post(Jason.encode!(params), headers("POST", path, params, config))
    |> parse_response()
  end

  @spec delete(path, config | nil) :: response
  def delete(path, config \\ nil) do
    config = Config.config_or_env_config(config)

    path
    |> url(config)
    |> HTTPoison.delete(headers("DELETE", path, %{}, config))
    |> parse_response()
  end

  defp headers(method, path, body, config) do
    timestamp = ExOkex.Auth.timestamp()
    signed = ExOkex.Auth.sign(timestamp, method, path, body, config.api_secret)

    [
      "Content-Type": "application/json",
      "OK-ACCESS-KEY": config.api_key,
      "OK-ACCESS-SIGN": signed,
      "OK-ACCESS-TIMESTAMP": timestamp,
      "OK-ACCESS-PASSPHRASE": config.api_passphrase
    ]
  end
end
