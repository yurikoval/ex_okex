defmodule ExOkex.Futures.CrossedPosition do
  alias __MODULE__

  @type t :: %CrossedPosition{
          long_qty: String.t(),
          long_avail_qty: String.t(),
          long_avg_cost: String.t(),
          long_settlement_price: String.t(),
          realised_pnl: String.t(),
          short_qty: String.t(),
          short_avail_qty: String.t(),
          short_avg_cost: String.t(),
          short_settlement_price: String.t(),
          liquidation_price: String.t(),
          instrument_id: String.t(),
          leverage: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          margin_mode: String.t(),
          short_margin: String.t(),
          short_pnl: String.t(),
          short_pnl_ratio: String.t(),
          short_unrealised_pnl: String.t(),
          long_margin: String.t(),
          long_pnl: String.t(),
          long_pnl_ratio: String.t(),
          long_unrealised_pnl: String.t(),
          long_settled_pnl: String.t(),
          short_settled_pnl: String.t(),
          last: String.t()
        }

  defstruct ~w(
    long_qty
    long_avail_qty
    long_avg_cost
    long_settlement_price
    realised_pnl
    short_qty
    short_avail_qty
    short_avg_cost
    short_settlement_price
    liquidation_price
    instrument_id
    leverage
    created_at
    updated_at
    margin_mode
    short_margin
    short_pnl
    short_pnl_ratio
    short_unrealised_pnl
    long_margin
    long_pnl
    long_pnl_ratio
    long_unrealised_pnl
    long_settled_pnl
    short_settled_pnl
    last
  )a
end
