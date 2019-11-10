defmodule ExOkex.Futures.Private.CreateBulkOrders do
  import ExOkex.Api.Private

  @prefix "/api/futures/v3"

  def create_bulk_orders(params, config \\ nil) do
    "#{@prefix}/orders"
    |> post(params, config)
  end
end
