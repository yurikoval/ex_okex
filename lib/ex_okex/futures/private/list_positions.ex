defmodule ExOkex.Futures.Private.ListPositions do
  import ExOkex.Api.Private
  alias ExOkex.Futures

  @prefix "/api/futures/v3"

  def list_positions(config \\ nil) do
    "#{@prefix}/position"
    |> get(%{}, config)
    |> parse_response()
  end

  defp parse_response({:ok, %{"holding" => holding}}) do
    positions =
      holding
      |> Enum.flat_map(fn holding_item ->
        holding_item
        |> Enum.map(fn
          %{"margin_mode" => "crossed"} = data -> data |> to_crossed_struct
          %{"margin_mode" => "fixed"} = data -> data |> to_fixed_struct
        end)
      end)
      |> Enum.map(fn {:ok, p} -> p end)

    {:ok, positions}
  end

  defp parse_response({:error, _} = error), do: error

  defp to_crossed_struct(data), do: data |> Mapail.map_to_struct(Futures.CrossedPosition)
  defp to_fixed_struct(data), do: data |> Mapail.map_to_struct(Futures.FixedPosition)
end
