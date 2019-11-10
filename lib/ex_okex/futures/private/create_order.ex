defmodule ExOkex.Futures.Private.CreateOrder do
  import ExOkex.Api.Private

  @prefix "/api/futures/v3"

  def create_order(params, config \\ nil) do
    "#{@prefix}/orders"
    |> post(params, config)
  end
end
