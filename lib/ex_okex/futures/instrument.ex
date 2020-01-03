defmodule ExOkex.Futures.Instrument do
  @moduledoc """
  Futures instrument struct holding contract information

  https://www.okex.com/docs/en/#futures-contract_information
  """

  alias __MODULE__

  @type t :: %Instrument{
          alias: String.t(),
          base_currency: String.t(),
          contract_val: String.t(),
          contract_val_currency: String.t(),
          delivery: String.t(),
          instrument_id: String.t(),
          is_inverse: String.t(),
          listing: String.t(),
          quote_currency: String.t(),
          settlement_currency: String.t(),
          tick_size: String.t(),
          trade_increment: String.t(),
          underlying: String.t(),
          underlying_index: String.t()
        }

  defstruct ~w(
    alias
    base_currency
    contract_val
    contract_val_currency
    delivery
    instrument_id
    is_inverse
    listing
    quote_currency
    settlement_currency
    tick_size
    trade_increment
    underlying
    underlying_index
  )a
end
