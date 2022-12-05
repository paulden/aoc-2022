defmodule AdventOfCode.Day05 do
  @crate_mover_9000_after_order &Enum.reverse/1
  @crate_mover_9001_after_order &Function.identity/1

  def part1(args) do
    move_crates(args, @crate_mover_9000_after_order)
  end

  def part2(args) do
    move_crates(args, @crate_mover_9001_after_order)
  end

  defp move_crates(args, crate_mover) do
    [crates, instructions] =
      args
      |> String.split("\n\n")
      |> Enum.map(fn line -> String.split(line, "\n", trim: true) end)

    max_height = Enum.count(crates)

    stacks_number =
      Enum.at(crates, max_height - 1)
      |> String.split(" ", trim: true)
      |> Enum.count()

    initial_stacks =
      1..stacks_number
      |> Enum.reduce(%{}, fn stack_number, stacks ->
        current_stack =
          0..(max_height - 1)
          |> Enum.map(fn height ->
            crates
            |> Enum.at(height)
            |> String.at(4 * stack_number - 3)
          end)
          |> Enum.reject(&is_nil/1)
          |> Enum.reject(fn x -> x == " " end)

        Map.put(stacks, stack_number, current_stack)
      end)

    final_stacks =
      instructions
      |> Enum.reduce(initial_stacks, fn instruction, stacks ->
        [move, from, to] = parse_instruction(instruction)

        {moving_crates, _} = stacks[from] |> Enum.split(move)

        stacks
        |> Map.put(from, stacks[from] -- moving_crates)
        |> Map.put(to, crate_mover.(moving_crates) ++ stacks[to])
      end)

    1..stacks_number
    |> Enum.map(fn n -> final_stacks[n] end)
    |> Enum.map(&List.first/1)
    |> Enum.join()
  end

  defp parse_instruction(instruction) do
    instruction
    |> String.split(" ")
    |> Enum.map(&Integer.parse/1)
    |> Enum.filter(fn res -> res != :error end)
    |> Enum.map(fn {i, _} -> i end)
  end
end
