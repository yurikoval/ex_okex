defmodule ExOkex.Spot.PublicTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExOkex.Spot

  test ".instruments returns a list" do
    use_cassette "spot/public/instruments_ok" do
      assert {:ok, instruments} = Spot.Public.instruments()

      assert Enum.any?(instruments) == true
      assert %Spot.Instrument{} = instrument = instruments |> hd()
      assert instrument.instrument_id != nil
    end
  end

  test ".instruments bubbles errors" do
    with_mock HTTPoison,
      get: fn _url, _headers -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout} = Spot.Public.instruments()
    end
  end
end
