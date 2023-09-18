defmodule FactChecker do
  alias FactChecker.Storage.ETS

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

  def insert_args(rest) do
    # this is done don't touch
    [hd | args] = rest

    parsed = parser(args)
    ETS.insert(hd, parsed)
  end

  def query_args(rest) do
    [hd | args] = rest
    parsed = parser(args)
    query = [hd, parsed] |> List.flatten() |> List.to_tuple()

    ETS.handle_query(hd, parsed)
  end

  defp parser(args) do
    Enum.map(args, fn str ->
      Regex.scan(~r/[a-zA-Z0-9_]+/, str)
    end)
    |> List.flatten()
  end
end

# notes: when given X then X becomes the 
