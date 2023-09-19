defmodule FactChecker.Parser do
  def parser(pattern) do
    #change into $1 $2 etc...
#if true add to list
map_with_index = pattern
|> Enum.uniq()
|> Enum.filter(fn el -> is_variable?(el) end)
|> Enum.with_index(1)
|> Map.new

modified_list = Enum.map(pattern, fn element ->
  case Map.get(map_with_index, element) do
    nil -> element
    value -> :"$#{value}"
  end
end)

IO.inspect(modified_list)
  end

  def is_variable?(str) do
    if String.match?(str, ~r/^[A-Z]/) do
      true
    else
      false
    end
  end
end