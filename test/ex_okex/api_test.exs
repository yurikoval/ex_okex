defmodule ExOkex.ApiTest do
  use ExUnit.Case, async: false
  import TestHelper

  test "rate_limited error" do
    response = http_response('', 429)

    with_mock_request(:get, response, fn ->
      assert {:error, :rate_limited} =
               HTTPoison.get("https://www.example.com", []) |> ExOkex.Api.parse_response()
    end)
  end
end
