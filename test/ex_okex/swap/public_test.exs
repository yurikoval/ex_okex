defmodule ExOkex.Swap.PublicTest do
  use ExUnit.Case, async: false
  import TestHelper
  alias ExOkex.Swap

  test ".instruments returns a list" do
    with_cassette("swap/public/instruments_ok", fn ->
      assert {:ok, instruments} = Swap.Public.instruments()

      assert Enum.any?(instruments) == true
      assert %Swap.Instrument{} = instrument = instruments |> hd()
      assert instrument.instrument_id != nil
    end)
  end

  test ".instruments bubbles errors" do
    response = {:error, %HTTPoison.Error{reason: :timeout}}

    with_mock_request(:get, response, fn ->
      assert {:error, :timeout} = Swap.Public.instruments()
    end)
  end
end
