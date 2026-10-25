defmodule ExOkex.Spot.PublicTest do
  use ExUnit.Case, async: false
  import TestHelper
  alias ExOkex.Spot

  test ".instruments returns a list" do
    with_cassette("spot/public/instruments_ok", fn ->
      assert {:ok, instruments} = Spot.Public.instruments()

      assert Enum.any?(instruments) == true
      assert %Spot.Instrument{} = instrument = instruments |> hd()
      assert instrument.instrument_id != nil
    end)
  end

  test ".instruments bubbles errors" do
    response = {:error, %HTTPoison.Error{reason: :timeout}}

    with_mock_request(:get, response, fn ->
      assert {:error, :timeout} = Spot.Public.instruments()
    end)
  end
end
