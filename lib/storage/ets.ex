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

  def lookup(key) do
    :ets.lookup(:facts, key)
  end

  def handle_query(key, values) do
    list = [key | values]

    res = Parser.parser(list)

    matched = :ets.match_object(:facts, res)
    
    IO.inspect(list)

    Parser.format_results(matched, list)

    placeholder_list = Enum.map(list, fn str -> is_variable?(str) end)
    ets_list = List.to_tuple(placeholder_list)

    if Enum.any?(placeholder_list, fn el -> el == :_ end) do
      query_with_placeholders(placeholder_list, values)
    else
      :ok
    end
  end



  def query_with_placeholders(placeholder_list, pattern) do
    [key | values] = placeholder_list

    placeholder_list =
      placeholder_list
      |> convert_to_erl()
      |> List.to_tuple()

    matched = :ets.match_object(:facts, placeholder_list)

    case values do
      [:_] -> find_all(key, values) |> write_to_file
      [:_, :_] -> double_associations(matched, pattern)
      _ -> many_associations(matched, [placeholder_list], pattern)
    end
  end

  def find_all(key, value) do
    list = lookup(key)

    if list != [] do
      Enum.map(list, fn {_key, value} -> value end)
    else
      "false\n"
    end
  end

  # queries that look for values based on two placeholders
  def double_associations(matched, pattern) do
    input_list = Enum.map(matched, fn t -> Tuple.delete_at(t, 0) |> Tuple.to_list() end)
    [p_1, p_2] = pattern

    if p_1 == p_2 do
      for [val_1, val_2] <- input_list, val_1 == val_2 do
        val_1
      end
      |> write_to_file
    else
      for [val_1, val_2] <- input_list, val_1 != val_2 do
        [p1, p2] = Enum.map(pattern, fn str -> String.to_atom(str) end)
        ["{#{p1}: #{val_1}, #{p2}: #{val_2}}"]
      end
      |> write_to_file()
    end
  end

  def many_associations(matched, placeholders, pattern) do
    input_list = Enum.map(matched, fn t -> Tuple.delete_at(t, 0) |> Tuple.to_list() end)

    placeholder_list =
      Enum.map(placeholders, fn t -> Tuple.delete_at(t, 0) |> Tuple.to_list() end)
      |> List.flatten()

    if length(placeholder_list) == 2 do
      index_to_remove = Enum.find_index(placeholder_list, fn x -> x != :_ end)

      Enum.map(input_list, fn sublist -> List.delete_at(sublist, index_to_remove) end)
      |> write_to_file
    else
      pattern_map =
        Enum.map(input_list, fn sublist -> Enum.zip(pattern, sublist) end)
        |> Enum.map(fn sublist -> create_map(sublist) end)

      reduced_list = Enum.map(pattern_map, fn submap -> reduce_to_final(submap, pattern) end)

      if input_list == reduced_list do
        Enum.map(pattern_map, fn map ->
          res = Map.to_list(map) |> format_list
          "{#{res}}"
        end)
        |> write_to_file
      else
        write_to_file("false \n")
      end
      |> IO.inspect()
    end
  end

  def format_list(tuple) do
    for {key, value} <- tuple do
      "#{key}: #{value}"
    end
    |> Enum.join(", ")
  end

  def reduce_to_final(submap, pattern) do
    Enum.map(pattern, fn p ->
      value = Map.get(submap, p)

      case value do
        nil -> p
        value -> value
      end
    end)
  end

  def create_map(list) do
    unique_key_value_pairs =
      for {key, value} <-
            list
            |> Enum.uniq_by(fn {k, _} -> k end)
            |> Enum.filter(fn {k, _} -> String.match?(k, ~r/^[A-Z]/) end),
          into: %{} do
        {key, value}
      end
  end

  # write to file
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

  def convert_to_erl(list) do
    for item <- list do
      case item do
        "X" -> :_
        "Y" -> :_
        _ -> item
      end
    end
  end

  # helpers
  def is_variable?(str) do
    if String.match?(str, ~r/^[A-Z]/) do
      :_
    else
      str
    end
  end
end
