defmodule ExOkex.Futures.Public do
  import ExOkex.Api.Private

  @prefix "/api/futures/v3"

  def instruments do
    get("#{@prefix}/instruments", %{})
  end
end
