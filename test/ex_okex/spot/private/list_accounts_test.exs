defmodule ExOkex.Spot.Private.ListAccountsTest do
  use ExUnit.Case
  import TestHelper
  alias ExOkex.Spot

  @config %ExOkex.Config{
    api_key: "OKEX_API_KEY",
    api_secret: Base.encode64("OKEX_API_SECRET"),
    api_passphrase: "OKEX_API_PASSPHRASE"
  }

  test "returns list of accounts" do
    response = http_response([%{"balance" => "0.00"}], 200)

    with_mock_request(:get, response, fn ->
      assert {:ok, [%{"balance" => "0.00"}]} == Spot.Private.list_accounts()
    end)
  end

  test "accepts dynamically specified config" do
    response = http_response([%{"balance" => "0.00"}], 200)

    with_mock_request(:get, response, fn ->
      assert {:ok, [%{"balance" => "0.00"}]} == Spot.Private.list_accounts(@config)
    end)
  end
end
