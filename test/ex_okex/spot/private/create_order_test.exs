defmodule ExOkex.Spot.Private.CreateOrderTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Spot

  test "returns placed order" do
    response = http_response(%{"price" => "1.00"}, 201)

    with_mock_request(:post, response, fn ->
      assert {:ok, %{"price" => "1.00"}} ==
               Spot.Private.create_order(%{
                 side: "buy",
                 product_id: "ETH-USD",
                 price: "1.00"
               })
    end)
  end
end
