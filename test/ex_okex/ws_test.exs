defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExOkex.Ws
end

defmodule ExOkex.WsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  describe "initial state" do
    setup do
      {:ok, socket} = WsWrapper.start_link()
      {:ok, socket: socket}
    end

    test "subscribe", %{socket: socket} do
      :ok = WsWrapper.subscribe(socket)

      Process.sleep(2000)
    end

    test "login", %{socket: socket} do
      :ok = WsWrapper.login(socket)

      Process.sleep(1000)
    end
  end
end
