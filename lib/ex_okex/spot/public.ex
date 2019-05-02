defmodule ExOkex.Spot.Public do
  import ExOkex.Api.Public

  @prefix "/api/spot/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end
end
