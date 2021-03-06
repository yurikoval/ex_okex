defmodule ExOkex.Swap.Private.AmendBulkOrders do
  import ExOkex.Api.Private

  @prefix "/api/swap/v3"

  def amend_bulk_orders(instrument_id, params, config \\ nil) do
    "#{@prefix}/amend_batch_orders/#{instrument_id}"
    |> post(params, config)
  end
end
