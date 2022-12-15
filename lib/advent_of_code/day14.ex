defmodule AdventOfCode.Day14 do
  @sand_source {500, 0}

  def part1(args) do
    rocks = parse_rocks(args)

    count_sand_resting(rocks, @sand_source, 0)
  end

  def part2(args) do
    rocks = parse_rocks(args)

    floor_level =
      rocks
      |> Map.values()
      |> Enum.reduce([], fn levels, acc -> levels ++ acc end)
      |> Enum.max()
      |> Kernel.+(2)

    count_sand_resting_with_floor(rocks, @sand_source, 0, floor_level)
  end

  defp count_sand_resting(units, {column, level}, sand_poured) do
    if Map.has_key?(units, column) and
         units[column] |> Enum.any?(fn element -> element >= level end) do
      if Enum.member?(units[column], level + 1) do
        # Blocked at the middle
        cond do
          not Map.has_key?(units, column - 1) or not Enum.member?(units[column - 1], level + 1) ->
            # Can move diagonally to the left
            count_sand_resting(units, {column - 1, level + 1}, sand_poured)

          not Map.has_key?(units, column + 1) or not Enum.member?(units[column + 1], level + 1) ->
            # Can move diagonally to the right
            count_sand_resting(units, {column + 1, level + 1}, sand_poured)

          true ->
            # Cannot move diagonally, resting
            count_sand_resting(
              units |> Map.put(column, [level | units[column]]),
              @sand_source,
              sand_poured + 1
            )
        end
      else
        # Not blocked, continuing fall
        count_sand_resting(units, {column, level + 1}, sand_poured)
      end
    else
      # Free falling
      sand_poured
    end
  end

  defp count_sand_resting_with_floor(units, {column, level}, sand_poured, floor_level) do
    if Map.has_key?(units, column) and
         units[column] |> Enum.any?(fn element -> element >= level end) do
      if Enum.member?(units[column], level + 1) do
        # Blocked at the middle
        cond do
          not Map.has_key?(units, column - 1) or not Enum.member?(units[column - 1], level + 1) ->
            # Can move diagonally to the left
            count_sand_resting_with_floor(
              units,
              {column - 1, level + 1},
              sand_poured,
              floor_level
            )

          not Map.has_key?(units, column + 1) or not Enum.member?(units[column + 1], level + 1) ->
            # Can move diagonally to the right
            count_sand_resting_with_floor(
              units,
              {column + 1, level + 1},
              sand_poured,
              floor_level
            )

          true ->
            # Cannot move diagonally, resting
            if {column, level} == @sand_source do
              sand_poured + 1
            else
              count_sand_resting_with_floor(
                units |> Map.put(column, [level | units[column]]),
                @sand_source,
                sand_poured + 1,
                floor_level
              )
            end
        end
      else
        # Not blocked, continuing fall
        count_sand_resting_with_floor(units, {column, level + 1}, sand_poured, floor_level)
      end
    else
      # Falling on the floor
      new_units =
        if Map.has_key?(units, column) do
          units |> Map.put(column, [floor_level - 1 | units[column]])
        else
          units |> Map.put(column, [floor_level - 1])
        end

      count_sand_resting_with_floor(
        new_units,
        @sand_source,
        sand_poured + 1,
        floor_level
      )
    end
  end

  defp parse_rocks(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn path, rocks ->
      path
      |> String.split(" -> ", trim: true)
      |> Enum.map(&parse_corner/1)
      |> Enum.reduce({rocks, {}}, fn corner, {path_rocks, latest_corner} ->
        if latest_corner == {} do
          {path_rocks, corner}
        else
          {
            path_rocks |> add_all_between_points(latest_corner, corner),
            corner
          }
        end
      end)
      |> elem(0)
    end)
  end

  defp parse_corner(corner) do
    corner
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp add_all_between_points(existing, {x1, y1}, {x2, y2}) do
    x1..x2
    |> Enum.reduce(existing, fn x, updated ->
      y1..y2
      |> Enum.reduce(updated, fn y, acc ->
        if Map.has_key?(acc, x) do
          acc |> Map.put(x, [y | acc[x]] |> Enum.uniq())
        else
          acc |> Map.put(x, [y])
        end
      end)
    end)
  end

  defp pretty_print(rocks) do
    0..11
    |> Enum.map(fn y ->
      IO.write("#{y} ")

      490..510
      |> Enum.map(fn x ->
        if Map.has_key?(rocks, x) and rocks[x] |> Enum.member?(y) do
          IO.write("#")
        else
          IO.write(".")
        end
      end)

      IO.write("\n")
    end)
  end
end
