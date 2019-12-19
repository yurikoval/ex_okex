defmodule ExOkex.Spot.Private.ListAccounts do
  import ExOkex.Api.Private

  @prefix "/api/spot/v3"
  @path "#{@prefix}/accounts"

  def list_accounts(config \\ nil) do
    @path
    |> get(%{}, config)
  end
end
