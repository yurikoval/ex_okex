defmodule ExOkex.Futures.Public do
  @moduledoc """
  Public Futures Client

  https://www.okex.com/docs/en/#futures-README
  """

  alias ExOkex.Futures.Public

  defdelegate instruments, to: Public.Instruments
end
