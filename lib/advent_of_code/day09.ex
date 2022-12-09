defmodule AdventOfCode.Day09 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce({MapSet.new([{0, 0}]), List.duplicate({0, 0}, 2)}, fn move,
                                                                         {tail_visited_positions,
                                                                          knots_positions} ->
      [direction, steps_string] = move |> String.split(" ")
      steps = String.to_integer(steps_string)

      {new_visited_positions, new_knots_positions} =
        0..(steps - 1)
        |> Enum.reduce({tail_visited_positions, knots_positions}, fn _,
                                                                     {visited_positions,
                                                                      positions} ->
          knot0_position = positions |> Enum.at(0) |> get_new_head_position(direction)
          knot1_position = positions |> Enum.at(1) |> get_new_tail_position(knot0_position)
          {visited_positions |> MapSet.put(knot1_position), [knot0_position, knot1_position]}
        end)

      {new_visited_positions, new_knots_positions}
    end)
    |> elem(0)
    |> MapSet.size()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce({MapSet.new([{0, 0}]), List.duplicate({0, 0}, 10)}, fn move,
                                                                          {tail_visited_positions,
                                                                           knots_positions} ->
      [direction, steps_string] = move |> String.split(" ")
      steps = String.to_integer(steps_string)

      {new_visited_positions, new_knots_positions} =
        0..(steps - 1)
        |> Enum.reduce({tail_visited_positions, knots_positions}, fn _,
                                                                     {visited_positions,
                                                                      positions} ->
          knot0_position = positions |> Enum.at(0) |> get_new_head_position(direction)
          knot1_position = positions |> Enum.at(1) |> get_new_tail_position(knot0_position)
          knot2_position = positions |> Enum.at(2) |> get_new_tail_position(knot1_position)
          knot3_position = positions |> Enum.at(3) |> get_new_tail_position(knot2_position)
          knot4_position = positions |> Enum.at(4) |> get_new_tail_position(knot3_position)
          knot5_position = positions |> Enum.at(5) |> get_new_tail_position(knot4_position)
          knot6_position = positions |> Enum.at(6) |> get_new_tail_position(knot5_position)
          knot7_position = positions |> Enum.at(7) |> get_new_tail_position(knot6_position)
          knot8_position = positions |> Enum.at(8) |> get_new_tail_position(knot7_position)
          knot9_position = positions |> Enum.at(9) |> get_new_tail_position(knot8_position)

          new_pos = [
            knot0_position,
            knot1_position,
            knot2_position,
            knot3_position,
            knot4_position,
            knot5_position,
            knot6_position,
            knot7_position,
            knot8_position,
            knot9_position
          ]

          {visited_positions |> MapSet.put(knot9_position), new_pos}
        end)

      {new_visited_positions, new_knots_positions}
    end)
    |> elem(0)
    |> Enum.count()
  end

  defp get_new_head_position(head_position, direction) do
    {x, y} = head_position

    case direction do
      "R" -> {x + 1, y}
      "L" -> {x - 1, y}
      "U" -> {x, y + 1}
      "D" -> {x, y - 1}
    end
  end

  defp get_new_tail_position(tail_position, head_position) do
    {x_h, y_h} = head_position
    {x_t, y_t} = tail_position

    cond do
      # Horizontal and vertical
      x_h == x_t and y_h > y_t + 1 -> {x_h, y_h - 1}
      x_h == x_t and y_h < y_t - 1 -> {x_h, y_h + 1}
      y_h == y_t and x_h > x_t + 1 -> {x_h - 1, y_h}
      y_h == y_t and x_h < x_t - 1 -> {x_h + 1, y_h}
      # Fully diagonal
      x_h > x_t + 1 and y_h > y_t + 1 -> {x_h - 1, y_h - 1}
      x_h < x_t - 1 and y_h < y_t - 1 -> {x_h + 1, y_h + 1}
      x_h > x_t + 1 and y_h < y_t - 1 -> {x_h - 1, y_h + 1}
      x_h < x_t - 1 and y_h > y_t + 1 -> {x_h + 1, y_h - 1}
      # Diagonal
      x_h > x_t + 1 and abs(y_h - y_t) <= 1 -> {x_h - 1, y_h}
      x_h < x_t - 1 and abs(y_h - y_t) <= 1 -> {x_h + 1, y_h}
      y_h > y_t + 1 and abs(x_h - x_t) <= 1 -> {x_h, y_h - 1}
      y_h < y_t - 1 and abs(x_h - x_t) <= 1 -> {x_h, y_h + 1}
      true -> if (abs(x_h - x_t) > 1 or abs(y_h - y_t) > 1) do
        IO.puts("Head is at (#{x_h}, #{y_h}) while tail is at (#{x_t}, #{y_t}), not moving tail?")
        tail_position
      else
        tail_position
      end
    end
  end

  defp pretty_print(positions) do
    -15..15
    |> Enum.map(fn y ->
      -15..15
      |> Enum.map(fn x ->
        cond do
          positions |> Enum.any?(fn pos -> pos == {x, -y} end) -> IO.write("#")
          {x, y} == {0, 0} -> IO.write("s")
          true -> IO.write(".")
        end
      end)

      IO.write("\n")
    end)
  end
end
