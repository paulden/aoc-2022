defmodule AdventOfCode.Day09 do
  def part1(args) do
    move_rope(args, 2)
  end

  def part2(args) do
    move_rope(args, 10)
  end

  defp move_rope(args, knots) do
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
                                                                      current_positions} ->
          head_position =
            current_positions
            |> Enum.at(0)
            |> get_new_head_position(direction)

          new_pos =
            1..(knots - 1)
            |> Enum.reduce([head_position], fn knot, pos ->
              previous_knot = Enum.reverse(pos) |> hd()

              current_knot =
                current_positions
                |> Enum.at(knot)
                |> get_new_tail_position(previous_knot)

              pos ++ [current_knot]
            end)

          knot9_position = Enum.reverse(new_pos) |> hd()

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
      # No move required
      true -> tail_position
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
