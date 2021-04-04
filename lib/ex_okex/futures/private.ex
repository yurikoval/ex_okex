defmodule ExOkex.Futures.Private do
  @moduledoc """
  Futures account client.

  [API docs](https://www.okex.com/docs/en/#futures-README)
  """

  alias ExOkex.Futures.Private

  @type params :: map
  @type instrument_id :: String.t()
  @type config :: ExOkex.Config.t()
  @type response :: ExOkex.Api.response()

  @doc """
  Place a new order.

  ## Examples

  iex> ExOkex.Futures.create_order(%{
    instrument_id: "BTC-USD-180213",
    leverage: "10",
    orders_data: [%{
      type: "1",
      price: "432.11",
      size: "2",
      match_price: "0"
    }]
  })
  {:ok, %{"order_info" => [%{"error_code" => 0, "error_message" => "", "order_id" => "2653481276189696"}], "result" => true}}
  """
  @spec create_order(params, config | nil) :: response
  defdelegate create_order(params, config \\ nil), to: Private.CreateOrder

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#futures-batch

  ## Examples

  iex> ExOkex.Futures.create_bulk_orders([
    %{"instrument_id":"BTC-USD-180213",
      "type":"1",
      "price":"432.11",
      "size":"2",
      "match_price":"0",
      "leverage":"10" },
    ])

  """
  @spec create_bulk_orders([params], config | nil) :: response
  defdelegate create_bulk_orders(params, config \\ nil), to: Private.CreateBulkOrders

  defdelegate create_batch_orders(params, config \\ nil),
    to: Private.CreateBulkOrders,
    as: :create_bulk_orders

  @doc """
  Cancelling an unfilled order.

  https://www.okex.com/docs/en/#futures-repeal

  ## Example

  iex> ExOkex.Futures.cancel_orders("BTC-USD-180309", [1600593327162368,1600593327162369])

  """
  defdelegate cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil),
    to: Private.CancelOrders

  @doc """
  Amend multiple open orders for a specific trading pair (up to 10 orders)

  https://www.okex.com/docs/en/#futures-amend_batch

  ## Examples

  iex> ExOkex.Futures.amend_bulk_orders("BTC-USD-180213", [
    %{amend_data: [
      %{order_id: "305512815291895607",new_size: "2"},
      %{order_id: "305512815291895606",new_size: "1"}
    ]})

  """
  @spec amend_bulk_orders(instrument_id, params, config | nil) :: response
  defdelegate amend_bulk_orders(instrument_id, params, config \\ nil), to: Private.AmendBulkOrders

  @doc """
  Get the futures account info of all token.

  https://www.okex.com/docs/en/#futures-singleness

  ## Examples

  iex> ExOkex.Futures.list_accounts()

  """
  defdelegate list_accounts(config \\ nil), to: Private.ListAccounts

  @doc """
  Retrieve information on your positions of a single contract.

  https://www.okex.com/docs/en/#futures-hold_information

  ## Examples

  iex> ExOkex.Futures.Private.position("BTC-USD-190329")

  """
  defdelegate position(instrument_id, config \\ nil), to: Private.Position

  @doc """
  Retrieve the information on all your positions in the futures account.

  https://www.okex.com/docs/en/#futures-hold_information

  ## Examples

  iex> ExOkex.Futures.Private.list_positions()

  """
  defdelegate list_positions(config \\ nil), to: Private.ListPositions
end
