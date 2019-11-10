defmodule ExOkex.Swap.Private.ListAccounts do
  import ExOkex.Api.Private

  @prefix "/api/swap/v3"

  def list_accounts(config \\ nil) do
    "#{@prefix}/accounts"
    |> get(%{}, config)
  end
end
