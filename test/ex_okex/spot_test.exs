defmodule ExOkex.SpotTest do
  use ExUnit.Case

  import TestHelper

  describe ".create_order" do
    test "returns placed order" do
      response = http_response(%{"price" => "1.00"}, 201)

      with_mock_request(:post, response, fn ->
        assert {:ok, %{"price" => "1.00"}} ==
                 ExOkex.Spot.create_order(%{side: "buy", product_id: "ETH-USD", price: "1.00"})
      end)
    end
  end

  describe ".list_accounts" do
    test "returns list of accounts" do
      response = http_response([%{"balance" => "0.00"}], 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, [%{"balance" => "0.00"}]} == ExOkex.Spot.list_accounts()
      end)
    end

    test "accepts dynamically specified config" do
      config = %ExOkex.Config{
        api_key: "OKEX_API_KEY",
        api_secret: Base.encode64("OKEX_API_SECRET"),
        api_passphrase: "OKEX_API_PASSPHRASE"
      }

      response = http_response([%{"balance" => "0.00"}], 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, [%{"balance" => "0.00"}]} == ExOkex.Spot.list_accounts(config)
      end)
    end
  end
end
