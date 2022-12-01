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
    backpacks =
      args
      |> String.split("\n")
      |> Enum.chunk_by(fn line -> line != "" end)
      |> Enum.reject(fn line -> line == [""] end)

    for backpack <- backpacks do
      backpack
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end
  end
end
