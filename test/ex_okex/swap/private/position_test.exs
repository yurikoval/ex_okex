defmodule ExOkex.Swap.Private.PositionTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Swap

  @config %ExOkex.Config{
    api_key: "OKEX_API_KEY",
    api_secret: Base.encode64("OKEX_API_SECRET"),
    api_passphrase: "OKEX_API_PASSPHRASE"
  }

  test "can return crossed positions" do
    data = %{
      "margin_mode" => "crossed",
      "timestamp" => "2019-09-27T03:49:02.018Z",
      "holding" => [
        %{
          "avail_position" => "3",
          "avg_cost" => "59.49",
          "instrument_id" => "LTC-USD-SWAP",
          "last" => "55.79",
          "leverage" => "10.00",
          "liquidation_price" => "4.37",
          "maint_margin_ratio" => "0.0100",
          "margin" => "0.0537",
          "position" => "3",
          "realized_pnl" => "0.0000",
          "settled_pnl" => "-0.0330",
          "settlement_price" => "55.84",
          "side" => "long",
          "timestamp" => "2019-09-27T03:49:02.018Z"
        }
      ]
    }

    response = http_response(data, 200)

    with_mock_request(:get, response, fn ->
      assert {:ok, positions} = Swap.Private.position("LTC-USD-SWAP", @config)
      assert Enum.count(positions) == 1

      assert [%Swap.CrossedPosition{} = position | _] = positions
      assert position.instrument_id == "LTC-USD-SWAP"
      assert position.leverage == "10.00"
    end)
  end

  test "can return fixed positions" do
    data = %{
      "margin_mode" => "fixed",
      "timestamp" => "2019-09-27T03:47:37.230Z",
      "holding" => [
        %{
          "avail_position" => "20",
          "avg_cost" => "8025.0",
          "instrument_id" => "BTC-USD-SWAP",
          "last" => "8113.1",
          "leverage" => "15.00",
          "liquidation_price" => "7002.6",
          "maint_margin_ratio" => "0.0050",
          "margin" => "0.0454",
          "position" => "20",
          "realized_pnl" => "-0.0001",
          "settled_pnl" => "0.0076",
          "settlement_price" => "8279.2",
          "side" => "long",
          "timestamp" => "2019-09-27T03:47:37.230Z"
        }
      ]
    }

    response = http_response(data, 200)

    with_mock_request(:get, response, fn ->
      assert {:ok, positions} = Swap.Private.position("BTC-USD-SWAP", @config)
      assert Enum.count(positions) == 1

      assert [%Swap.FixedPosition{} = position | _] = positions
      assert position.instrument_id == "BTC-USD-SWAP"
      assert position.leverage == "15.00"
    end)
  end
end
