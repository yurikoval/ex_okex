defmodule ExOkex.Futures.Private.ListPositionsTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Futures

  @config %ExOkex.Config{
    api_key: "OKEX_API_KEY",
    api_secret: Base.encode64("OKEX_API_SECRET"),
    api_passphrase: "OKEX_API_PASSPHRASE"
  }

  test "returns crossed & fixed positions" do
    data = %{
      "result" => true,
      "holding" => [
        [
          %{
            "long_qty" => "2",
            "long_avail_qty" => "2",
            "long_avg_cost" => "8260",
            "long_settlement_price" => "8260",
            "realised_pnl" => "0.00020928",
            "short_qty" => "2",
            "short_avail_qty" => "2",
            "short_avg_cost" => "8259.99",
            "short_settlement_price" => "8259.99",
            "liquidation_price" => "113.81",
            "instrument_id" => "BTC-USD-191227",
            "leverage" => "10",
            "created_at" => "2019-09-25T07:58:42.129Z",
            "updated_at" => "2019-10-08T14:02:51.029Z",
            "margin_mode" => "crossed",
            "short_margin" => "0.00242197",
            "short_pnl" => "6.63E-6",
            "short_pnl_ratio" => "0.002477997",
            "short_unrealised_pnl" => "6.63E-6",
            "long_margin" => "0.00242197",
            "long_pnl" => "-6.65E-6",
            "long_pnl_ratio" => "-0.002478",
            "long_unrealised_pnl" => "-6.65E-6",
            "long_settled_pnl" => "0",
            "short_settled_pnl" => "0",
            "last" => "8257.57"
          },
          %{
            "long_qty" => "4",
            "long_avail_qty" => "4",
            "long_margin" => "0.00323844",
            "long_liqui_price" => "7762.09",
            "long_pnl_ratio" => "0.06052306",
            "long_avg_cost" => "8234.43",
            "long_settlement_price" => "8234.43",
            "realised_pnl" => "-0.00000296",
            "short_qty" => "2",
            "short_avail_qty" => "2",
            "short_margin" => "0.00241105",
            "short_liqui_price" => "9166.74",
            "short_pnl_ratio" => "0.03318052",
            "short_avg_cost" => "8295.13",
            "short_settlement_price" => "8295.13",
            "instrument_id" => "BTC-USD-191227",
            "long_leverage" => "15",
            "short_leverage" => "10",
            "created_at" => "2019-09-25T07 => 58 => 42.129Z",
            "updated_at" => "2019-10-08T13 => 12 => 09.438Z",
            "margin_mode" => "fixed",
            "short_margin_ratio" => "0.10292507",
            "short_maint_margin_ratio" => "0.005",
            "short_pnl" => "7.853E-5",
            "short_unrealised_pnl" => "7.853E-5",
            "long_margin_ratio" => "0.07103743",
            "long_maint_margin_ratio" => "0.005",
            "long_pnl" => "1.9841E-4",
            "long_unrealised_pnl" => "1.9841E-4",
            "long_settled_pnl" => "0",
            "short_settled_pnl" => "0",
            "last" => "8266.99"
          }
        ]
      ]
    }

    response = http_response(data, 200)

    with_mock_request(:get, response, fn ->
      assert {:ok, positions} = Futures.Private.list_positions(@config)
      assert Enum.count(positions) == 2

      assert %Futures.CrossedPosition{} = crossed_position = Enum.at(positions, 0)
      assert crossed_position.instrument_id == "BTC-USD-191227"
      assert crossed_position.leverage == "10"

      assert %Futures.FixedPosition{} = fixed_position = Enum.at(positions, 1)
      assert fixed_position.instrument_id == "BTC-USD-191227"
      assert fixed_position.long_leverage == "15"
      assert fixed_position.short_leverage == "10"
    end)
  end
end
