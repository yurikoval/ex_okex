defmodule ExOkex.Swap.Public do
  import ExOkex.Api.Public

  @prefix "/api/swap/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end
end
