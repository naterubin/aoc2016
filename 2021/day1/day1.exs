defmodule Radar do
  def scanner(readings) do
    check_increase(readings, 0)
  end

  defp check_increase([_ | []], acc) do
    acc
  end

  defp check_increase([h | t], acc) do
    [next_h | _] = t
    if h < next_h do
      check_increase(t, acc + 1)
    else
      check_increase(t, acc)
    end
  end

  def load_readings(file_name) do
    {:ok, input} = File.read(file_name)
    input_by_line = String.split(input, "\n")
    input_by_line = if List.last(input_by_line) == "" do
      elem(Enum.split(input_by_line, length(input_by_line) - 1), 0)
    else
      input_by_line
    end
    input_by_line |> Enum.map(&Integer.parse/1) |> Enum.map(fn t -> elem(t, 0) end)
  end
end

IO.puts(Radar.load_readings("input.txt") |> Radar.scanner)
