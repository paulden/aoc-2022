defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, ",") end)
    |> Enum.filter(fn pair ->
      pair
      |> Enum.map(&parse_elf_range/1)
      |> Enum.zip()
      |> range_contains_another()
    end)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, ",") end)
    |> Enum.filter(fn pair ->
      pair
      |> Enum.map(&parse_elf_range/1)
      |> Enum.zip()
      |> range_overlaps()
    end)
    |> Enum.count()
  end

  defp range_contains_another([{start_A, start_B}, {end_A, end_B}]) do
    (start_A <= start_B && end_B <= end_A) || (start_B <= start_A && end_A <= end_B)
  end

  defp range_overlaps([{start_A, start_B}, {end_A, end_B}]) do
    start_A <= end_B && end_A >= start_B
  end

  defp parse_elf_range(string_range) do
    string_range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
  end
end
