defmodule ExOkex.Swap.Public do
  import ExOkex.Api.Public
  alias ExOkex.Swap

  @type instrument :: Swap.Instrument.t()
  @type error_reason :: term

  @prefix "/api/swap/v3"
  @instruments_path "#{@prefix}/instruments"

  def instruments do
    @instruments_path
    |> get()
    |> parse_response()
  end

  defp parse_response({:ok, data}) do
    instruments =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, i} -> i end)

    {:ok, instruments}
  end

  defp parse_response({:error, _} = error), do: error

  defp to_struct(data), do: data |> Mapail.map_to_struct(Swap.Instrument)
end
