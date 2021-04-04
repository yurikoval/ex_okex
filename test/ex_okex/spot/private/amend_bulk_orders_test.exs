defmodule ExOkex.Spot.Private.AmendBulkOrdersTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Spot

  test "returns successfully updated order" do
    response =
      http_response(
        %{
          "btc_usdt" => [
            %{
              "client_oid" => "",
              "code" => "0",
              "error_code" => "0",
              "error_message" => "",
              "message" => "",
              "order_id" => "6736780776963904",
              "request_id" => "",
              "result" => true
            }
          ]
        },
        200
      )

    with_mock_request(:post, response, fn ->
      assert {:ok,
              %{
                "btc_usdt" => [
                  %{"order_id" => "6736780776963904"}
                ]
              }} =
               Spot.Private.amend_bulk_orders([
                 %{
                   "instrument_id" => "BTC-USDT",
                   "order_id" => "6736780776963904",
                   "new_size" => "2"
                 }
               ])
    end)
  end
end
