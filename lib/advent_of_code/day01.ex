defmodule AdventOfCode.Day01 do
  def part1(args) do
    sum_backpacks_calories(args)
    |> Enum.max()
  end

  def part2(args) do
    sum_backpacks_calories(args)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp sum_backpacks_calories(args) do
    args
    |> String.split("\n")
    |> Stream.chunk_by(fn line -> line != "" end)
    |> Stream.reject(fn line -> line == [""] end)
    |> Stream.map(fn calories ->
      calories
      |> Stream.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end
end
