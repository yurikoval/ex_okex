defmodule ExOkex.Spot.Private.CancelOrdersTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExOkex.Spot

  @config %ExOkex.Config{
    api_key: "OKEX_API_KEY",
    api_secret: Base.encode64("OKEX_API_SECRET"),
    api_passphrase: "OKEX_API_PASSPHRASE"
  }

  test ".cancel_orders" do
    use_cassette "spot/private/cancel_ok" do
      {:ok, %{"order_id" => order_id}} =
        Spot.Private.create_order(
          %{
            side: "buy",
            product_id: "BTC-USDT",
            size: "0.001",
            price: "61000.0"
          },
          @config
        )

      assert {:ok, response} = Spot.Private.cancel_orders("BTC-USDT", [order_id], %{}, @config)

      assert %{
               "btc-usdt" => [
                 %{
                   "client_oid" => "",
                   "code" => "0",
                   "error_code" => "0",
                   "error_message" => "",
                   "message" => "",
                   "order_id" => ^order_id,
                   "result" => true
                 }
                 | _
               ]
             } = response
    end
  end
end
