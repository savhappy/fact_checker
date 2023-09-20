defmodule FactChecker do
  alias FactChecker.Storage.ETS
  alias FactChecker.Parser
  alias FactChecker.Writer

  def process_script(script_file) do
    File.stream!(script_file)
    |> Enum.reduce(%{}, fn line, facts ->
      case String.split(line, " ", trim: true) do
        ["INPUT" | rest] ->
          insert_args(rest)

        ["QUERY" | rest] ->
          query_args(rest)

        _ ->
          IO.puts("Invalid script line: #{line}")
          facts
      end
    end)
  end

  # handle inserts
  def insert_args(rest) do

    [hd | args] = rest

    parsed = validate(args)
    ETS.insert(hd, parsed)
    |> IO.inspect
  end

  # handle queries
  def query_args(rest) do
    [hd | args] = rest

    handle_query(hd, validate(args))
  end

  def handle_query(key, values) do
    pattern = [key | values]

    res = Parser.parser(pattern)

    matched = :ets.match_object(:facts, res)

    cond do
      matched == [] -> Writer.write_to_file("false\n")
      matched != [] -> Parser.parser_to_write(pattern, matched)
    end
  end

  # helpers
  defp validate(args) do
    Enum.map(args, fn str ->
      Regex.scan(~r/[a-zA-Z0-9_]+/, str)
    end)
    |> List.flatten()
  end
end
