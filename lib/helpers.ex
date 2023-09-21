defmodule FactChecker.Helpers do
  def size_of_map(map) when Kernel.map_size(map) == 1 do
    Map.values(map)
  end

  def size_of_map(map) when Kernel.map_size(map) > 1 do
    res = Map.to_list(map) |> format_list
    "{#{res}}"
  end

  def format_list(tuple) do
    for {key, value} <- tuple do
      "#{key}: #{value}"
    end
    |> Enum.join(", ")
  end

  def is_variable?(str) do
    String.match?(str, ~r/^[A-Z]/)
  end

  def validate(args) do
    Enum.map(args, fn str ->
      Regex.scan(~r/[a-zA-Z0-9_]+/, str)
    end)
    |> List.flatten()
  end
end
