defmodule ExOkex.Futures.Private.AmendBulkOrdersTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Futures

  test "returns successfully updated order" do
    response =
      http_response(
        %{
          "order_info" => [
            %{
              "client_oid" => "oktfutures14",
              "order_id" => "305512815291895606",
              "request_id" => "okfuturesBTCUSDmod002",
              "error_code" => "0",
              "error_message" => "",
              "result" => "true"
            },
            %{
              "client_oid" => "oktfutures15",
              "order_id" => "305512815291895607",
              "request_id" => "okfuturesBTCUSDmod001",
              "error_code" => "0",
              "error_message" => "",
              "result" => "true"
            }
          ],
          "result" => "true"
        },
        200
      )

    with_mock_request(:post, response, fn ->
      assert {:ok,
              %{
                "order_info" => [
                  %{"order_id" => "305512815291895606"},
                  %{"order_id" => "305512815291895607"}
                ]
              }} =
               Futures.Private.amend_bulk_orders("BTC-USD-180213", %{
                 amend_data: [
                   %{order_id: "305512815291895606", new_size: "2"},
                   %{order_id: "305512815291895607", new_size: "1"}
                 ]
               })
    end)
  end
end
