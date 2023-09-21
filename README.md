# FactChecker

Fact Checker is a dictionary to store facts. You may input facts into the dictionary or query for them. The format of the text files ingested should match:

```
INPUT is_a_cat (lucy)
INPUT is_a_cat (mel)
QUERY is_a_cat (lucy)
```
Feel free to use the included examples folder.

## Instructions

Welcome to Fact Checker! To run the program simply use the following command in your cli

Ingest Input File
```
mix run init_read.exs examples/1/in.txt
or 
mix run init_read.exs {name_of_input_file_to_ingest}
```
The program writes to the out folder and to 1.txt. View the results of your code there.

To run test:

```
mix test
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fact_checker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fact_checker, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/fact_checker>.

