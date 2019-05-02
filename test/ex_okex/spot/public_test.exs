defmodule ExOkex.Spot.PublicTest do
  use ExUnit.Case

  import TestHelper

  alias ExOkex.Spot.Public, as: Api

  describe ".instruments" do
    test "returns the instruments" do
      instruments = [
        %{
          "base_currency" => "BTC",
          "instrument_id" => "BTC-USDT",
          "min_size" => "0.001",
          "quote_currency" => "USDT",
          "size_increment" => "0.00000001",
          "tick_size" => "0.1"
        }
      ]

      response = http_response(instruments, 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, returned_instruments} = Api.instruments()
        assert returned_instruments == instruments
      end)
    end
  end
end
