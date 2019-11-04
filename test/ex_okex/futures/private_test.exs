defmodule ExOkex.Futures.PrivateTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Futures

  @config %ExOkex.Config{
    api_key: "OKEX_API_KEY",
    api_secret: Base.encode64("OKEX_API_SECRET"),
    api_passphrase: "OKEX_API_PASSPHRASE"
  }

  describe ".create_order" do
    test "returns placed order" do
      response = http_response(%{"price" => "1.00"}, 201)

      with_mock_request(:post, response, fn ->
        assert {:ok, %{"price" => "1.00"}} =
                 Futures.Private.create_order(%{side: "buy", product_id: "ETH-USD", price: "1.00"})
      end)
    end
  end

  describe ".list_accounts" do
    test "returns list of accounts" do
      response = http_response([%{"balance" => "0.00"}], 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, [%{"balance" => "0.00"}]} == Futures.Private.list_accounts()
      end)
    end

    test "can pass config as a parameter" do
      response = http_response([%{"balance" => "0.00"}], 200)

      with_mock_request(:get, response, fn ->
        assert {:ok, [%{"balance" => "0.00"}]} == Futures.Private.list_accounts(@config)
      end)
    end
  end
end
