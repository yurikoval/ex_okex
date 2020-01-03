defmodule ExOkex.Swap.Instrument do
  @moduledoc """
  Swap instrument struct holding contract information

  https://www.okex.com/docs/en/#swap-swap---contract_information
  """

  alias __MODULE__

  @type t :: %Instrument{
          base_currency: String.t(),
          coin: String.t(),
          contract_val: String.t(),
          contract_val_currency: String.t(),
          delivery: String.t(),
          instrument_id: String.t(),
          is_inverse: boolean,
          listing: String.t(),
          quote_currency: String.t(),
          settlement_currency: String.t(),
          size_increment: String.t(),
          tick_size: String.t(),
          underlying: String.t(),
          underlying_index: String.t()
        }

  defstruct ~w(
    base_currency
    coin
    contract_val
    contract_val_currency
    delivery
    instrument_id
    is_inverse
    listing
    quote_currency
    settlement_currency
    size_increment
    tick_size
    underlying
    underlying_index
  )a
end
