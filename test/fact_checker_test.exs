defmodule FactCheckerTest do
  use ExUnit.Case
  alias FactChecker.Storage.ETS

  setup_all do
    ets = ETS.start_link()
    %{ets: ets}
  end

  describe "process_script/1" do
    test "streams file and divides into inserts or queries", %{ets: ets} do
      assert FactChecker.process_script("in/1.txt") == :ok
    end
  end

  describe "insert_args/1" do
    value = ["is_a_cat", "(lucy)\n"]

    assert true
  end
end
