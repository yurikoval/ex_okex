defmodule ExOkex.Swap.PublicTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExOkex.Swap

  test ".instruments returns a list" do
    use_cassette "swap/public/instruments_ok" do
      assert {:ok, instruments} = Swap.Public.instruments()

      assert Enum.any?(instruments) == true
      assert %Swap.Instrument{} = instrument = instruments |> hd()
      assert instrument.instrument_id != nil
    end
  end

  test ".instruments bubbles errors" do
    with_mock HTTPoison,
      get: fn _url, _headers -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout} = Swap.Public.instruments()
    end
  end
end
