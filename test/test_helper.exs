ExUnit.start()

defmodule TestHelper do
  use ExUnit.Case, async: false

  def with_mock_request(:get, response, fun) do
    with_mock_request({:get, fn _url, _headers -> response end}, fun)
  end

  def with_mock_request(:post, response, fun) do
    with_mock_request({:post, fn _url, _body, _headers -> response end}, fun)
  end

  def with_mock_request(:delete, response, fun) do
    with_mock_request({:delete, fn _url, _headers -> response end}, fun)
  end

  def with_mock_request({method, callback}, fun) do
    :ok = :meck.new(HTTPoison, [:passthrough])
    :ok = :meck.expect(HTTPoison, method, callback)

    try do
      fun.()
    after
      :ok = :meck.unload(HTTPoison)
    end
  end

  def with_cassette(name, fun) do
    exchanges =
      "../fixture/vcr_cassettes/#{name}.json"
      |> Path.expand(__DIR__)
      |> File.read!()
      |> Jason.decode!()

    {:ok, exchanges} = Agent.start_link(fn -> exchanges end)
    :ok = :meck.new(HTTPoison, [:passthrough])

    exchanges
    |> Agent.get(& &1)
    |> Enum.map(& &1["request"]["method"])
    |> Enum.uniq()
    |> Enum.each(&expect_cassette_method(&1, exchanges))

    try do
      fun.()
      assert Agent.get(exchanges, & &1) == []
    after
      :ok = :meck.unload(HTTPoison)
      Agent.stop(exchanges)
    end
  end

  def http_response(map, status_code) do
    {:ok, json} = Jason.encode(map)
    {:ok, %HTTPoison.Response{body: json, status_code: status_code}}
  end

  defp expect_cassette_method("get", exchanges) do
    :ok =
      :meck.expect(HTTPoison, :get, fn url, headers ->
        replay(exchanges, "get", url, "", headers)
      end)
  end

  defp expect_cassette_method("post", exchanges) do
    :ok =
      :meck.expect(HTTPoison, :post, fn url, body, headers ->
        replay(exchanges, "post", url, body, headers)
      end)
  end

  defp replay(exchanges, method, url, body, headers) do
    exchange =
      Agent.get_and_update(exchanges, fn [exchange | rest] -> {exchange, rest} end)

    request = exchange["request"]
    response = exchange["response"]

    assert request["method"] == method
    assert request["url"] == url
    assert decode_body(request["body"]) == decode_body(body)
    assert header_names(request["headers"]) == header_names(headers)

    {:ok,
     %HTTPoison.Response{
       body: response["body"],
       headers: Map.to_list(response["headers"]),
       status_code: response["status_code"]
     }}
  end

  defp decode_body(""), do: nil
  defp decode_body(body), do: Jason.decode!(body)

  defp header_names(headers) do
    headers
    |> Enum.map(fn {name, _value} -> name |> to_string() |> String.downcase() end)
    |> Enum.sort()
  end
end
