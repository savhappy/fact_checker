defmodule FactChecker.Parser do
  alias FactChecker.Storage.ETS

  def parser(pattern) do
    map_with_index =
      pattern
      |> Enum.uniq()
      |> Enum.filter(fn el -> is_variable?(el) end)
      |> Enum.with_index(1)
      |> Map.new()

    Enum.map(pattern, fn element ->
      case Map.get(map_with_index, element) do
        nil -> element
        value -> :"$#{value}"
      end
    end)
    |> List.to_tuple()
   
  end

  def parser_to_write(pattern, matched) do
    [key | value] = pattern
    variables = Enum.any?(pattern, fn x -> is_variable?(x) end)
    if(length(value) == 1 && variables != true) do
      write_to_file("true\n")
    else

      matched_list = Enum.map(matched, fn el -> Tuple.to_list(el) end)
      |> Enum.map(fn sublist -> sublist -- pattern end)
      |> IO.inspect
  
      only_variables = Enum.filter(pattern, fn x -> is_variable?(x) end)
      
      Enum.map(matched_list, fn sublist -> Enum.zip(only_variables, sublist) |> Map.new |> size_of_map end) 
      |> List.flatten 
      |> write_to_file
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


  def write_to_file(data) when is_list(data) do
    file_content = Enum.join(data, " ") <> "\n"
    file_name = "out/1.txt"

    if File.exists?(file_name) do
      File.open(file_name, [:append]) |> elem(1) |> IO.binwrite(file_content)
    else
      File.write(file_name, file_content)
    end
  end

  def write_to_file(data) do
    file_name = "out/1.txt"

    if File.exists?(file_name) do
      File.open(file_name, [:append]) |> elem(1) |> IO.binwrite(data)
    else
      File.write(file_name, data)
    end
  end

  def is_variable?(str) do
    if String.match?(str, ~r/^[A-Z]/) do
      true
    else
      false
    end
  end

end
