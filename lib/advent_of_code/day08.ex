defmodule AdventOfCode.Day08 do
  def part1(args) do
    tree_map = parse_tree_map(args)

    left_visibility =
      tree_map
      |> Enum.map(&get_visibility/1)
      |> List.flatten()

    top_visibility =
      tree_map
      |> transpose()
      |> Enum.map(&get_visibility/1)
      |> transpose()
      |> List.flatten()

    right_visibility =
      tree_map
      |> Enum.map(fn l -> Enum.reverse(l) end)
      |> Enum.map(&get_visibility/1)
      |> Enum.map(fn l -> Enum.reverse(l) end)
      |> List.flatten()

    bottom_visibility =
      tree_map
      |> transpose()
      |> Enum.map(fn l -> Enum.reverse(l) end)
      |> Enum.map(&get_visibility/1)
      |> Enum.map(fn l -> Enum.reverse(l) end)
      |> transpose()
      |> List.flatten()

    0..(length(left_visibility) - 1)
    |> Enum.filter(fn n ->
      Enum.at(left_visibility, n) == :v or Enum.at(top_visibility, n) == :v or
        Enum.at(right_visibility, n) == :v or Enum.at(bottom_visibility, n) == :v
    end)
    |> Enum.count()
  end

  def part2(args) do
    tree_map = parse_tree_map(args)
    length = length(tree_map)
    width = length(hd(tree_map))

    0..(width - 1)
    |> Enum.map(fn x ->
      0..(length - 1)
      |> Enum.map(fn y ->
        current_height =
          tree_map
          |> Enum.at(y)
          |> Enum.at(x)

        {left, right} =
          tree_map
          |> Enum.at(y)
          |> Enum.split(x)

        {top, bottom} =
          tree_map
          |> transpose()
          |> Enum.at(x)
          |> Enum.split(y)

        visible_left_trees =
          left
          |> Enum.reverse()
          |> count_visible_trees_in_sight(current_height)

        visible_right_trees =
          right
          |> tl()
          |> count_visible_trees_in_sight(current_height)

        visible_top_trees =
          top
          |> Enum.reverse()
          |> count_visible_trees_in_sight(current_height)

        visible_bottom_trees =
          bottom
          |> tl()
          |> count_visible_trees_in_sight(current_height)

        visible_left_trees * visible_right_trees * visible_top_trees * visible_bottom_trees
      end)
      |> Enum.max()
    end)
    |> Enum.max()
  end

  defp get_visibility(line) do
    line
    |> Enum.reduce({-1, []}, fn current_height, {top_height, visibility} ->
      if current_height > top_height do
        {current_height, visibility ++ [:v]}
      else
        {top_height, visibility ++ [:x]}
      end
    end)
    |> elem(1)
  end

  defp count_visible_trees_in_sight(row, current_height) do
    row
    |> Enum.reduce_while(0, fn tree_height, visible_trees ->
      if tree_height < current_height do
        {:cont, visible_trees + 1}
      else
        {:halt, visible_trees + 1}
      end
    end)
  end

  defp transpose(matrix) do
    matrix
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp parse_tree_map(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
