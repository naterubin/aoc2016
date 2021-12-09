defmodule Radar do
  def scanner(readings) do
    check_increase(readings, 0)
  end

  def windowed_scanner(readings) do
    make_windows(readings, [])
    |> Enum.map(&Enum.sum/1)
    |> check_increase(0)
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

  defp next_three(l) do
    case l do
      [] -> []
      [h1 | []] -> [h1]
      [h1 | [h2 | []]] -> [h1, h2]
      [h1 | [h2 | [h3 | _]]] -> [h1, h2, h3]
    end
  end

  defp make_windows([], acc) do
    acc
  end

  defp make_windows(l, acc) do
    [_ | tail] = l
    make_windows(tail, acc ++ [next_three(l)])
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
IO.puts(Radar.load_readings("input.txt") |> Radar.windowed_scanner)
