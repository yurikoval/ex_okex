defmodule ExOkex.Spot.Private do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"

  @moduledoc """
  Spot account client.
  """

  @doc """
  Place a new order.

  Refer to params listed in [API docs](https://www.okex.com/docs/en/#spot-orders)

  ## Examples

      iex> ExOkex.Spot.Private.create_order(%{type: "limit", side: "buy", product_id: "ETH-USD", price: "0.50", size: "1.0"})
      #TODO: Add response sample
  """
  def create_order(params, config \\ nil) do
    post("#{@prefix}/orders", params, config)
  end

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#spot-batch

  ## Examples

  iex> ExOkex.Spot.Private.create_bulk_orders([
    { "client_oid":"20180728",
      "instrument_id":"btc-usdt",
      "side":"sell",
      "type":"limit",
      "size":"0.001",
      "price":"10001",
      "margin_trading ":"1"},
    { "client_oid":"20180728",
      "instrument_id":"btc-usdt",
      "side":"sell",
      "type":"limit",
      "size":"0.001",
      "price":"10002",
      "margin_trading ":"1"}
    ])

    # TODO: Add response sample

  """
  def create_bulk_orders(params, config \\ nil) do
    post("#{@prefix}/batch_orders", params, config)
  end

  defdelegate create_batch_orders(params, config \\ nil), to: __MODULE__, as: :create_bulk_orders

  @doc """
  Get the balance, amount available/on hold of a token in spot account.

  [Spot Trading Account of a Currency](https://www.okex.com/docs/en/#spot-singleness)

  ## Example

          iex(1)> ExOkex.Spot.Private.get_balance("btc")
          {:ok,
           %{
             "available" => "0.005",
             "balance" => "0.005",
             "currency" => "btc",
             "frozen" => "0",
             "hold" => "0",
             "holds" => "0",
             "id" => "2006057"
           }}
  """
  def get_balance(currency, config \\ nil) do
    get("#{@prefix}/accounts/#{currency}", %{}, config)
  end

  @doc """
  Cancelling an unfilled order.

  https://www.okex.com/docs/en/#spot-revocation

  ## Example

  iex> ExOkex.Spot.Private.cancel_order("1611729012263936", %{"instrument_id":"btc-usdt"})
  # TODO: Add response
  """
  def cancel_order(order_id, %{} = params, config \\ nil) do
    post("#{@prefix}/cancel_orders/#{order_id}", params, config)
  end

  @doc """
  List accounts.

  ## Examples

        iex(3)> ExOkex.Spot.Private.list_accounts()
        {:ok,
         [
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
  def list_accounts(config \\ nil) do
    get("#{@prefix}/accounts", %{}, config)
  end
end
