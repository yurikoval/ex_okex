defmodule ExOkex.Swap.Private.Position do
  import ExOkex.Api.Private

  @prefix "/api/swap/v3"

  def position(instrument_id, config \\ nil) do
    "#{@prefix}/#{instrument_id}/position"
    |> get(%{}, config)
  end
end
