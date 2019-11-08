defmodule ExOkex.Swap.Private.ListPositions do
  import ExOkex.Api.Private
  alias ExOkex.Swap

  @prefix "/api/swap/v3"

  def list_positions(config \\ nil) do
    "#{@prefix}/position"
    |> get(%{}, config)
    |> parse_response()
  end

  defp parse_response({:ok, data}) when is_list(data) do
    positions =
      data
      |> Enum.flat_map(fn
        %{"margin_mode" => "crossed", "holding" => holding} ->
          holding |> Enum.map(&to_crossed_struct/1)

        %{"margin_mode" => "fixed", "holding" => holding} ->
          holding |> Enum.map(&to_fixed_struct/1)
      end)
      |> Enum.map(fn {:ok, p} -> p end)

    {:ok, positions}
  end

  defp parse_response({:error, _} = error), do: error

  defp to_crossed_struct(data), do: data |> Mapail.map_to_struct(Swap.CrossedPosition)
  defp to_fixed_struct(data), do: data |> Mapail.map_to_struct(Swap.FixedPosition)
end
