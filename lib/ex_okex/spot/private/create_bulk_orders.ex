defmodule ExOkex.Spot.Private.CreateBulkOrders do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"
  @path "#{@prefix}/batch_orders"

  def create_bulk_orders(params, config \\ nil) do
    @path
    |> post(params, config)
  end
end
