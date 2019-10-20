defmodule ExOkex.Futures.PublicTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExOkex.Futures

  test ".instruments returns a list" do
    use_cassette "futures/public/instruments_ok" do
      assert {:ok, instruments} = Futures.Public.instruments()

      assert Enum.any?(instruments) == true
      assert %Futures.Instrument{} = instrument = instruments |> hd()
      assert instrument.instrument_id != nil
    end
  end

  test ".instruments bubbles errors" do
    with_mock HTTPoison,
      get: fn _url, _headers -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout} = Futures.Public.instruments()
    end
  end
end
