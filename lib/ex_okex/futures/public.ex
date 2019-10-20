defmodule ExOkex.Futures.Public do
  import ExOkex.Api.Public
  alias ExOkex.Futures

  @type instrument :: Futures.Instrument.t()
  @type error_reason :: term

  @prefix "/api/futures/v3"
  @instruments_path "#{@prefix}/instruments"

  @spec instruments :: {:ok, [instrument]} | {:error, error_reason}
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

  defp to_struct(data), do: data |> Mapail.map_to_struct(Futures.Instrument)
end
