defmodule ExOkex.Futures.Public do
  import ExOkex.Api.Public

  @prefix "/api/futures/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end
end
