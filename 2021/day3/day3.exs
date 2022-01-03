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
    zero_count = Map.get(digit_counts, 0)
    one_count  = Map.get(digit_counts, 1)
    cond do
      zero_count == one_count -> 1
      zero_count >  one_count -> 0
      zero_count <  one_count -> 1
    end
  end

  defp least_common_digit(digit_counts) do
    zero_count = Map.get(digit_counts, 0)
    one_count  = Map.get(digit_counts, 1)
    cond do
      zero_count == one_count -> 0
      zero_count <  one_count -> 0
      zero_count >  one_count -> 1
    end
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

  def bit_criteria_rating(entries, bit_calc_func) do
    bit_criteria_rating(entries, 0, bit_calc_func)
  end

  def bit_criteria_rating([entry], _, _) do
    Integer.undigits(entry, 2)
  end

  def bit_criteria_rating(entries, place, bit_calc_func) do
    counts = build_digit_count(entries)
    desired_bit = bit_calc_func.(Enum.at(counts, place))
    filtered_entries = Enum.filter(entries, fn l -> Enum.at(l, place) == desired_bit end)
    bit_criteria_rating(filtered_entries, place + 1, bit_calc_func)
  end

  def o2_generator_rating(entries) do
    bit_criteria_rating(entries, &most_common_digit/1)
  end

  def co2_scrubber_rating(entries) do
    bit_criteria_rating(entries, &least_common_digit/1)
  end

  def life_support_rating(entries) do
    o2_generator_rating(entries) * co2_scrubber_rating(entries)
  end

  def get_input(file_name) do
    {:ok, input} = File.read(file_name)
    commands = String.split(input, "\n")
    {commands, _} = Enum.split(commands, length(commands) - 1)
    commands
  end
end

bitwise_inputs = Diagnostics.get_input("input.txt")
    |> Enum.map(&Diagnostics.parse_diag_entry/1)
