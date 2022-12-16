defmodule AdventOfCode.Day15 do
  def part1(args, row) do
    beacons_on_row = args
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, acc ->
      [_, {x, y}] =
        line
        |> String.split(": ", trim: true)
        |> Enum.map(&parse/1)
      if y == row do
        [x | acc]
      else
        acc
      end
    end)
    |> MapSet.new()

    args
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, sensors_radius ->
      [sensor, beacon] =
        line
        |> String.split(": ", trim: true)
        |> Enum.map(&parse/1)

      sensors_radius
      |> Map.put(sensor, get_manhattan_distance(sensor, beacon))
    end)
    # |> IO.inspect()
    |> Enum.reduce(%{}, fn {{x, y}, distance}, acc ->
      first_cross_x = distance - abs(row - y) + x
      second_cross_x = -distance + abs(row - y) + x

      if distance < abs(row - y) do
        acc
      else
        acc
        |> Map.put({x, y}, min(first_cross_x, second_cross_x)..max(first_cross_x, second_cross_x))
      end
    end)
    |> Map.values()
    |> IO.inspect()
    |> Enum.reduce(MapSet.new([]), fn range, impossible_beacon_positions ->
      range
      |> Enum.reduce(impossible_beacon_positions, fn x, acc ->
        acc |> MapSet.put(x)
      end)
      # |> IO.inspect()
    end)
    |> MapSet.difference(beacons_on_row)
    |> Enum.count()
  end

  defp parse("Sensor at " <> coordinates), do: parse(coordinates)
  defp parse("closest beacon is at " <> coordinates), do: parse(coordinates)

  defp parse(coordinates) do
    coordinates
    |> String.split(", ", trim: true)
    |> Enum.map(fn coordinate -> String.slice(coordinate, 2..-1) end)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp get_manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def part2(args) do
  end
end
