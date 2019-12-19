defmodule ExOkex.Spot.Private.CancelOrders do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"
  @path "#{@prefix}/cancel_batch_orders"

  def cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil) do
    new_params = params |> Map.merge(%{instrument_id: instrument_id, order_ids: order_ids})

    @path
    |> post(new_params, config)
  end
end
