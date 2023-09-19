defmodule FactChecker.Parser do
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

  def format_results(matched, pattern) when length(pattern) == 2 do
    cond do
      matched == [] -> write_to_file("false\n")
      matched != [] -> write_to_file("true\n")
    end
  end

  def format_results(result, pattern) do
    IO.puts("not here")
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
