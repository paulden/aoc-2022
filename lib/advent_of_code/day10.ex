defmodule AdventOfCode.Day10 do
  @noop "noop"

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce({[1], 1}, fn instruction, {values, x} ->
      if instruction == @noop do
        {values ++ [x], x}
      else
        value = instruction |> parse_value()
        {values ++ [x, x + value], x + value}
      end
    end)
    |> elem(0)
    |> Enum.reduce({0, 1}, fn x, {signal_strength, cycle} ->
      if rem(cycle + 20, 40) == 0 do
        {signal_strength + x * cycle, cycle + 1}
      else
        {signal_strength, cycle + 1}
      end
    end)
    |> elem(0)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], 1}, fn instruction, {render, x} ->
      pixel1_index = rem(length(render), 40)
      pixel1 = pixel1_index |> get_pixel(x)

      if instruction == @noop do
        {render ++ [pixel1], x}
      else
        value = instruction |> parse_value()
        pixel2_index = rem(pixel1_index + 1, 40)
        pixel2 = pixel2_index |> get_pixel(x)
        {render ++ [pixel1, pixel2], x + value}
      end
    end)
    |> elem(0)
    |> Enum.chunk_every(40)
    |> Enum.map(fn line ->
      line |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.write()
  end

  defp get_pixel(cycle, x) do
    if x - 1 <= cycle and cycle <= x + 1 do
      "#"
    else
      "."
    end
  end

  defp parse_value(instruction) do
    instruction
    |> String.split(" ")
    |> Enum.reverse()
    |> hd()
    |> String.to_integer()
  end
end
