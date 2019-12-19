defmodule ExOkex.Spot.Private do
  @moduledoc """
  Spot account client.

  [API docs](https://www.okex.com/docs/en/#spot-README)
  """

  alias ExOkex.Spot.Private

  @doc """
  Place a new order.

  Refer to params listed in [API docs](https://www.okex.com/docs/en/#spot-orders)

  ## Examples

  iex> ExOkex.Spot.Private.create_order(%{type: "limit", side: "buy", product_id: "ETH-USD", price: "0.50", size: "1.0"})
  {:ok, %{
    "client_oid" => "oktspot79",
    "error_code" => "",
    "error_message" => "",
    "order_id" => "2510789768709120",
    "result" => true
  }}
  """
  defdelegate create_order(params, config \\ nil), to: Private.CreateOrder

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#spot-batch

  ## Examples

  iex> ExOkex.Spot.Private.create_bulk_orders([
        %{
          "client_oid" => "20180728",
          "instrument_id" => "btc-usdt",
          "side" => "sell",
          "type" => "limit",
          "size" => "0.001",
          "price" => "10001",
          "margin_trading" => "1"
        },
        %{
          "client_oid":"20180729",
          "instrument_id":"btc-usdt",
          "side":"sell",
          "type":"limit",
          "size":"0.001",
          "price":"10002",
          "margin_trading ":"1"
        }
      ])
      {:ok, %{
        "btc_usdt" => [
          %{"client_oid" => "20180728", "error_code" => 0, "error_message" => "", "order_id" => "2510832677159936", "result" => true},
          %{"client_oid" => "20180729", "error_code" => 0, "error_message" => "", "order_id" => "2510832677225472", "result" => true}
        ]
      }}
  """
  defdelegate create_bulk_orders(params, config \\ nil), to: Private.CreateBulkOrders

  defdelegate create_batch_orders(params, config \\ nil),
    to: Private.CreateBulkOrders,
    as: :create_bulk_orders

  @doc """
  Cancelling an unfilled order.

  https://www.okex.com/docs/en/#spot-revocation

  ## Example

  iex> ExOkex.Spot.Private.cancel_orders("btc-usdt", ["1611729012263936"])
  # TODO: Add response
  """
  defdelegate cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil),
    to: Private.CancelOrders

  @doc """
  List accounts.

  ## Examples

  iex> ExOkex.Spot.Private.list_accounts()
  {:ok, [
    %{
      "available" => "0.005",
      "balance" => "0.005",
      "currency" => "BTC",
      "frozen" => "0",
      "hold" => "0",
      "holds" => "0",
      "id" => "2006257"
    }
  ]}
  """
  defdelegate list_accounts(config \\ nil), to: Private.ListAccounts

  @doc """
  Get the balance, amount available/on hold of a token in spot account.

  [Spot Trading Account of a Currency](https://www.okex.com/docs/en/#spot-singleness)

  ## Example

  iex> ExOkex.Spot.Private.get_account("btc")
  {:ok, %{
    "available" => "0.005",
    "balance" => "0.005",
    "currency" => "btc",
    "frozen" => "0",
    "hold" => "0",
    "holds" => "0",
    "id" => "2006057"
  }}
  """
  defdelegate get_account(currency, config \\ nil), to: Private.GetAccount
end
