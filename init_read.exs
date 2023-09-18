defmodule FactChecker.InitRead do
  alias FactChecker
  alias FactChecker.Storage.ETS

  ETS.start_link()
  File.mkdir_p!("out")

  System.argv()
  |> FactChecker.process_script()

end