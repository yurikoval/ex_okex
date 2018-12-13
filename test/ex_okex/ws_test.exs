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
  end
end
