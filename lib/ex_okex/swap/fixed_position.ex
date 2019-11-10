defmodule ExOkex.Swap.FixedPosition do
  alias __MODULE__

  @type t :: %FixedPosition{
          avail_position: String.t(),
          avg_cost: String.t(),
          instrument_id: String.t(),
          last: String.t(),
          leverage: String.t(),
          liquidation_price: String.t(),
          maint_margin_ratio: String.t(),
          margin: String.t(),
          position: String.t(),
          realized_pnl: String.t(),
          settled_pnl: String.t(),
          settlement_price: String.t(),
          side: String.t(),
          timestamp: String.t()
        }

  defstruct ~w(
    avail_position
    avg_cost
    instrument_id
    last
    leverage
    liquidation_price
    maint_margin_ratio
    margin
    position
    realized_pnl
    settled_pnl
    settlement_price
    side
    timestamp
  )a
end
