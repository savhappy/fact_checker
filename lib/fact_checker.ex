defmodule FactChecker do
  alias FactChecker.Storage.ETS
  alias FactChecker.Parser
  alias FactChecker.Writer
  alias FactChecker.Helpers

  def process_script(script_file) do
    File.stream!(script_file)
    |> Enum.reduce(%{}, fn line, facts ->
      case String.split(line, " ", trim: true) do
        ["INPUT" | rest] ->
          insert_args(rest)

        ["QUERY" | rest] ->
          handle_query(rest)

        _ ->
          IO.puts("Invalid script line: #{line}")
          facts
      end
    end)
  end

  # handle inserts
  def insert_args(rest) do

    [hd | args] = rest

    parsed = Helpers.validate(args)
    ETS.insert(hd, parsed)
  end

  # handle queries

  def handle_query(rest) do
    [key | values] = rest

    values = Helpers.validate(values)
    pattern = [key | values]

    matched = :ets.match_object(:facts, Parser.parser(pattern))

    cond do
      matched == [] -> Writer.write_to_file("false\n")
      matched != [] -> Parser.parser_to_write(pattern, matched)
    end
  end
end
