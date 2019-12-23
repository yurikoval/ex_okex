defmodule ExOkex.Spot.Private.CreateOrder do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"
  @path "#{@prefix}/orders"

  def create_order(params, config \\ nil) do
    @path
    |> post(params, config)
  end
end
