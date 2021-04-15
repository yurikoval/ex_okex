defmodule ExOkex.Api do
  @moduledoc """
  API Base
  """

  @type path :: String.t()
  @type config :: ExOkex.Config.t()
  @type params :: map
  @type status_code :: integer
  @type body :: term
  @type error_reason :: :rate_limited | term
  @type response :: {:ok, term} | {:error, error_reason} | {:error, body, status_code}

  @spec url(path, config) :: String.t()
  def url(path, config), do: config.api_url <> path

  @spec query_string(path, params) :: String.t()
  def query_string(path, params) when map_size(params) == 0, do: path

  def query_string(path, params) do
    query =
      params
      |> Enum.map(fn {key, val} -> "#{key}=#{val}" end)
      |> Enum.join("&")

    path <> "?" <> query
  end

  @spec parse_response(
          {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
          | {:error, HTTPoison.Error.t()}
        ) :: response
  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        case status_code do
          code when code in 200..299 -> {:ok, Jason.decode!(body)}
          429 -> {:error, :rate_limited}
          _ -> parse_error_body(body, status_code)
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_error_body(body, status_code) do
    case Jason.decode(body) do
      {:ok, json} -> {:error, {json["code"], json["message"]}, status_code}
      {:error, _} -> {:error, body, status_code}
    end
  end
end
