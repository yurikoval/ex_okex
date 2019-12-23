defmodule ExOkex.Spot.Private.GetAccount do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"

  def get_account(currency, config \\ nil) do
    "#{@prefix}/accounts/#{currency}"
    |> get(%{}, config)
  end
end
