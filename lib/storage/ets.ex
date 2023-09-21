defmodule FactChecker.Storage.ETS do

  def start_link() do
    :ets.new(:facts, [:bag, :public, :named_table])
  end

  def insert(key, values) do
    list = [key, values] |> List.flatten()
    :ets.insert(:facts, List.to_tuple(list))
  end
end
