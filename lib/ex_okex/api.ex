defmodule ExOkex.Api do
  @type path :: String.t()
  @type config :: ExOkex.Config.t()
  @type params :: map

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

  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: code}} ->
        if code in 200..299 do
          {:ok, Jason.decode!(body)}
        else
          case Jason.decode(body) do
            {:ok, json} -> {:error, {json["code"], json["message"]}, code}
            {:error, _} -> {:error, body, code}
          end
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
