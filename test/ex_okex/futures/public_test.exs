defmodule ExOkex.Futures.PublicTest do
  use ExUnit.Case, async: false
  import TestHelper
  alias ExOkex.Futures

  test ".instruments returns a list" do
    with_cassette("futures/public/instruments_ok", fn ->
      assert {:ok, instruments} = Futures.Public.instruments()

      assert Enum.any?(instruments) == true
      assert %Futures.Instrument{} = instrument = instruments |> hd()
      assert instrument.instrument_id != nil
    end)
  end

  test ".instruments bubbles errors" do
    response = {:error, %HTTPoison.Error{reason: :timeout}}

    with_mock_request(:get, response, fn ->
      assert {:error, :timeout} = Futures.Public.instruments()
    end)
  end
end
