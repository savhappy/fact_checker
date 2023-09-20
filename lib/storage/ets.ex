defmodule FactChecker.Storage.ETS do

  alias FactChecker.Parser
  def start_link() do
    IO.inspect("start")
    :ets.new(:facts, [:bag, :protected, :named_table])
  end

  def insert(key, values) do
    list = [key, values] |> List.flatten()
    :ets.insert(:facts, List.to_tuple(list))
  end
end
