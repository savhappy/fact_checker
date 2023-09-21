defmodule FactChecker.Parser do
  alias FactChecker.Writer
  alias FactChecker.Helpers

  def parser(pattern) do
      pattern
      |> Enum.uniq()
      |> Enum.filter(fn el -> Helpers.is_variable?(el) end)
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
    [_key | value] = pattern
    variables = Enum.any?(pattern, &Helpers.is_variable?/1)

    if(length(value) == 1 && variables != true) do
      Writer.write_to_file("true\n")
    else
        compare_lists(pattern, matched)
        |> List.flatten()
        |> Writer.write_to_file()
    end
  end

  def compare_lists(pattern, matched) do
    only_variables = Enum.filter(pattern, &Helpers.is_variable?/1)

    Enum.map(matched, fn el -> Tuple.to_list(el) end)
    |> Enum.map(fn sublist -> sublist -- pattern end)
    |> Enum.map(fn sublist ->
      Enum.zip(only_variables, sublist)
      |> Map.new()
      |> Helpers.size_of_map
    end)
  end
end
