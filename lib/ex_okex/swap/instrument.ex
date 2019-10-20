defmodule ExOkex.Swap.Instrument do
  @moduledoc """
  Swap instrument struct holding contract information

  https://www.okex.com/docs/en/#swap-swap---contract_information
  """

  alias __MODULE__

  @type t :: %Instrument{
          coin: String.t(),
          contract_val: String.t(),
          delivery: String.t(),
          instrument_id: String.t(),
          listing: String.t(),
          quote_currency: String.t(),
          size_increment: String.t(),
          tick_size: String.t(),
          underlying_index: String.t()
        }

  defstruct ~w(
    coin
    contract_val
    delivery
    instrument_id
    listing
    quote_currency
    size_increment
    tick_size
    underlying_index
  )a
end
