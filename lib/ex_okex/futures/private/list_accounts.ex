defmodule ExOkex.Futures.Private.ListAccounts do
  import ExOkex.Api.Private

  @prefix "/api/futures/v3"

  def list_accounts(config \\ nil) do
    "#{@prefix}/accounts"
    |> get(%{}, config)
  end
end
