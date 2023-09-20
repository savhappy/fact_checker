defmodule FactChecker.Writer do
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
end
