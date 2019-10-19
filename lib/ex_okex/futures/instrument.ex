defmodule ExOkex.Futures.Instrument do
  alias __MODULE__

  @type t :: %Instrument{
          alias: String.t(),
          contract_val: String.t(),
          delivery: String.t(),
          instrument_id: String.t(),
          listing: String.t(),
          quote_currency: String.t(),
          tick_size: String.t(),
          trade_increment: String.t(),
          underlying_index: String.t()
        }

  defstruct ~w(
    alias
    contract_val
    delivery
    instrument_id
    listing
    quote_currency
    tick_size
    trade_increment
    underlying_index
  )a
end
