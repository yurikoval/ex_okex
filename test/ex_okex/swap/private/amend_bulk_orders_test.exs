defmodule ExOkex.Swap.Private.AmendBulkOrdersTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Swap

  test "returns successfully updated order" do
    response =
      http_response(
        %{
          "order_info" => [
            %{
              "client_oid" => "oktswaps14",
              "order_id" => "305512815291895606",
              "request_id" => "okswapsBTCUSDmod002",
              "error_code" => "0",
              "error_message" => "",
              "result" => "true"
            },
            %{
              "client_oid" => "oktswaps15",
              "order_id" => "305512815291895607",
              "request_id" => "okswapsBTCUSDmod001",
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
               Swap.Private.amend_bulk_orders("BTC-USD-SWAP", %{
                 amend_data: [
                   %{order_id: "305512815291895606", new_size: "2"},
                   %{order_id: "305512815291895607", new_size: "1"}
                 ]
               })
    end)
  end
end
