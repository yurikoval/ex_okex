defmodule ExOkex.Futures.Private.Position do
  import ExOkex.Api.Private
  alias ExOkex.Futures

  @prefix "/api/futures/v3"

  def position(instrument_id, config \\ nil) do
    "#{@prefix}/#{instrument_id}/position"
    |> get(%{}, config)
    |> parse_response()
  end

  defp parse_response({:ok, %{"margin_mode" => "crossed", "holding" => holdings}}) do
    positions =
      holdings
      |> Enum.map(&to_crossed_struct/1)
      |> Enum.map(fn {:ok, i} -> i end)

    {:ok, positions}
  end

  defp parse_response({:ok, %{"margin_mode" => "fixed", "holding" => holdings}}) do
    positions =
      holdings
      |> Enum.map(&to_fixed_struct/1)
      |> Enum.map(fn {:ok, i} -> i end)

    {:ok, positions}
  end

  defp parse_response({:error, _} = error), do: error

  defp to_crossed_struct(data), do: data |> Mapail.map_to_struct(Futures.CrossedPosition)
  defp to_fixed_struct(data), do: data |> Mapail.map_to_struct(Futures.FixedPosition)
end
