defmodule FactCheckerTest do
  use ExUnit.Case
  doctest FactChecker

  test "greets the world" do
    assert FactChecker.hello() == :world
  end
end
