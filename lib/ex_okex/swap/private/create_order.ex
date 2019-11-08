defmodule ExOkex.Swap.Private.CreateOrder do
  import ExOkex.Api.Private

  @prefix "/api/swap/v3"

  def create_order(params, config \\ nil) do
    "#{@prefix}/orders"
    |> post(params, config)
  end
end
