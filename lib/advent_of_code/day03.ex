defmodule AdventOfCode.Day03 do
  @alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn rucksack ->
      [first_compartment, second_compartment] =
        String.split_at(rucksack, div(String.length(rucksack), 2))
        |> Tuple.to_list()
        |> Enum.map(&String.graphemes/1)

      Enum.find(first_compartment, fn item -> item in second_compartment end)
    end)
    |> Enum.map(&get_priority/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [first, second, third] ->
      MapSet.intersection(MapSet.new(first), MapSet.new(second))
      |> MapSet.intersection(MapSet.new(third))
      |> MapSet.to_list()
      |> hd()
    end)
    |> Enum.map(&get_priority/1)
    |> Enum.sum()
  end

  defp get_priority(item) do
    :binary.match(@alphabet, item)
    |> elem(0)
    |> Kernel.+(1)
  end
end
