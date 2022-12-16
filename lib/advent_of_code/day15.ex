defmodule AdventOfCode.Day15 do
  def part1(args, row) do
    beacons_on_row =
      args
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
    |> Enum.reduce(MapSet.new([]), fn range, impossible_beacon_positions ->
      range
      |> Enum.reduce(impossible_beacon_positions, fn x, acc ->
        acc |> MapSet.put(x)
      end)
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
    0..4000000
    |> Enum.map(fn row ->
      if rem(row, 40000) == 0 do
        IO.puts("At #{row / 4000000 * 100}%")
      end

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
        |> Enum.reduce(%{}, fn {{x, y}, distance}, acc ->
          first_cross_x = distance - abs(row - y) + x
          second_cross_x = -distance + abs(row - y) + x

          if distance < abs(row - y) do
            acc
          else
            acc
            |> Map.put({x, y}, [
              min(first_cross_x, second_cross_x),
              max(first_cross_x, second_cross_x)
            ])
          end
        end)
        |> Map.values()
        |> Enum.sort(&(hd(&1) <= hd(&2)))
        |> Enum.reduce([], fn interval, merged_interval ->
          merge(interval, merged_interval)
        end)
    end)
    |> Enum.with_index()
    |> Enum.filter(fn {intervals, _} -> length(intervals) > 1 end)
    |> Enum.map(fn {interval, index} ->
      [first, second] = Enum.sort(interval, &(hd(&1) <= hd(&2)))
      x = div((Enum.at(first, 1) + Enum.at(second, 0)), 2)
      x * 4000000 + index
    end)
    |> hd()
  end

  defp merge([current_start, current_end], [[previous_start, previous_end] | tail]) do
    if current_start <= previous_end + 1 do
      [[previous_start, max(previous_end, current_end)] | tail]
    else
      [[current_start, current_end] | [[previous_start, previous_end] | tail]]
    end
  end

  defp merge(current_interval, []) do
    [current_interval]
  end
end
