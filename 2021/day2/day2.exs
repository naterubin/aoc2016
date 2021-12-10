defmodule Submarine do
  def parse_command(cmd_str) do
    case String.split(cmd_str, " ") do
      ["forward", qty] -> {:forward, elem(Integer.parse(qty), 0)}
      ["down", qty] -> {:down, elem(Integer.parse(qty), 0)}
      ["up", qty] -> {:up, elem(Integer.parse(qty), 0)}
    end
  end

  def execute_commands(commands) do
    move(commands, {0, 0, 0})
  end

  def get_result({hrz, vrt, _}) do
    hrz * vrt
  end

  defp move([], acc) do
    acc
  end

  defp move(commands, {hrz, vrt, aim}) do
    [command | rest] = commands
    new_pos = case command do
                {:forward, qty} -> {hrz + qty, vrt + (aim * qty), aim}
                {:up, qty} -> {hrz, vrt, aim - qty}
                {:down, qty} -> {hrz, vrt, aim + qty}
              end
    move(rest, new_pos)
  end

  def get_input(file_name) do
    {:ok, input} = File.read(file_name)
    commands = String.split(input, "\n")
    {commands, _} = Enum.split(commands, length(commands) - 1)
    commands
  end
end

IO.inspect(Submarine.get_input("input.txt")
    |> Enum.map(&Submarine.parse_command/1)
    |> Submarine.execute_commands
    |> Submarine.get_result)
