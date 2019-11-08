defmodule ExOkex.Swap.Private.CancelOrders do
  import ExOkex.Api.Private

  @prefix "/api/swap/v3"

  def cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil) do
    new_params = Map.merge(params, %{ids: order_ids})

    "#{@prefix}/cancel_batch_orders/#{instrument_id}"
    |> post(new_params, config)
  end
end
