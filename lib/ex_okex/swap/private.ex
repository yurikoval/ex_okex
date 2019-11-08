defmodule ExOkex.Swap.Private do
  @moduledoc """
  Swap account client.

  [API docs](https://www.okex.com/docs/en/#swap-README)
  """

  alias ExOkex.Swap.Private

  @type params :: map
  @type config :: ExOkex.Config.t()
  @type response :: ExOkex.Api.response()

  @doc """
  Place a new order.

  ## Examples

  iex> ExOkex.Swap.create_order(%{
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

  https://www.okex.com/docs/en/#swap-swap---batch

  ## Examples

  iex> ExOkex.Swap.create_bulk_orders([
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

  https://www.okex.com/docs/en/#swap-swap---revocation

  ## Example

      iex> ExOkex.Swap.cancel_orders("BTC-USD-180309", [1600593327162368,1600593327162369])

  """
  defdelegate cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil),
    to: Private.CancelOrders

  @doc """
  Get the swap account info of all token.

  https://www.okex.com/docs/en/#swap-singleness

  ## Examples

      iex(3)> ExOkex.Swap.list_accounts()

  """
  defdelegate list_accounts(config \\ nil), to: Private.ListAccounts

  @doc """
  Get the information of holding positions of a contract.

  https://www.okex.com/docs/en/#swap-hold_information

  ## Examples

      iex(3)> ExOkex.Swap.get_position("BTC-USD-190329")

  """
  defdelegate position(instrument_id, config \\ nil), to: Private.Position
end
