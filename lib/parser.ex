defmodule FactChecker.Parser do
  alias FactChecker.Storage.ETS
  alias FactChecker.Writer

  def parser(pattern) do
    map_with_index =
      pattern
      |> Enum.uniq()
      |> Enum.filter(fn el -> is_variable?(el) end)
      |> Enum.with_index(1)
      |> Map.new()
      |> map_parser(pattern)
  end

  def map_parser(map, pattern) do
    Enum.map(pattern, fn element ->
      case Map.get(map, element) do
        nil -> element
        value -> :"$#{value}"
      end
    end)
    |> List.to_tuple()
  end

  def parser_to_write(pattern, matched) do
    [key | value] = pattern
    variables = Enum.any?(pattern, &is_variable?/1)

    if(length(value) == 1 && variables != true) do
      Writer.write_to_file("true\n")
    else
      only_variables = Enum.filter(pattern, &is_variable?/1)

      matched_list =
        Enum.map(matched, fn el -> Tuple.to_list(el) end)
        |> Enum.map(fn sublist -> sublist -- pattern end)
        |> Enum.map(fn sublist ->
          Enum.zip(only_variables, sublist) |> Map.new() |> size_of_map
        end)
        |> List.flatten()
        |> Writer.write_to_file()
    end
  end

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
end
