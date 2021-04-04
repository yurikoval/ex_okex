defmodule ExOkex.Spot.Private.AmendBulkOrders do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"

  def amend_bulk_orders(params, config \\ nil) do
    "#{@prefix}/amend_batch_orders"
    |> post(params, config)
  end
end
