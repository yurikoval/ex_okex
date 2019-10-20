defmodule ExOkex.Spot.Instrument do
  alias __MODULE__

  @type t :: %Instrument{
          base_currency: String.t(),
          instrument_id: String.t(),
          min_size: String.t(),
          quote_currency: String.t(),
          size_increment: String.t(),
          tick_size: String.t()
        }

  defstruct ~w(
    base_currency
    instrument_id
    min_size
    quote_currency
    size_increment
    tick_size
  )a
end
