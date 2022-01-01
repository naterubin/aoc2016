defmodule Diagnostics do
  def build_digit_count(entries) do
    entry_length = length(Enum.at(entries, 0))
    build_digit_count(
      entries,
      Enum.map(Range.new(0, entry_length), fn _ -> %{0 => 0, 1 => 0} end)
    )
  end

  defp build_digit_count([], acc) do
    acc
  end

  defp build_digit_count([entry | rest], acc) do
    build_digit_count(rest, Enum.map(
      Enum.with_index(entry),
          fn {d, i} ->
            with counts <- Enum.at(acc, i) do
              Map.put(counts, d, Map.get(counts, d) + 1)
            end
          end
    ))
  end

  defp most_common_digit(digit_counts) do
    digit_counts |> Map.to_list
                 |> Enum.max_by(fn {_, v} -> v end)
                 |> elem(0)
  end

  defp least_common_digit(digit_counts) do
    digit_counts |> Map.to_list
                 |> Enum.min_by(fn {_, v} -> v end)
                 |> elem(0)
  end

  def gamma_rate(digit_counts) do
    Enum.map(digit_counts, &most_common_digit/1)
        |> Integer.undigits(2)
  end

  def epsilon_rate(digit_counts) do
    Enum.map(digit_counts, &least_common_digit/1)
        |> Integer.undigits(2)
  end

  def parse_diag_entry(entry) do
    chars = String.split(entry, "")
    chars |> Enum.slice(1, length(chars) - 2)
          |> Enum.map(&Integer.parse/1)
          |> Enum.map(&(elem(&1, 0)))
  end

  def get_input(file_name) do
    {:ok, input} = File.read(file_name)
    commands = String.split(input, "\n")
    {commands, _} = Enum.split(commands, length(commands) - 1)
    commands
  end
end

IO.inspect(Diagnostics.get_input("input.txt")
    |> Enum.map(&Diagnostics.parse_diag_entry/1)
    |> Diagnostics.build_digit_count
    |> (fn counts -> Diagnostics.gamma_rate(counts) * Diagnostics.epsilon_rate(counts) end).())
