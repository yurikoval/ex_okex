defmodule ExOkex.Futures.PublicTest do
  use ExUnit.Case

  import TestHelper

  alias ExOkex.Futures.Public, as: Api

  describe ".instruments" do
    test "returns the instruments" do
      instruments = [
        %{
          "instrument_id" => "BTC-USD-190322",
          "underlying_index" => "BTC",
          "quote_currency" => "USD",
          "tick_size" => "0.01",
          "contract_val" => "100",
          "listing" => "2019-03-08",
          "delivery" => "2019-03-22",
          "trade_increment" => "1",
          "alias" => "this_week"
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
