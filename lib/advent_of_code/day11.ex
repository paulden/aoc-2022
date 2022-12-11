defmodule AdventOfCode.Day11 do
  def part1(args) do
    worry_management = fn worry -> div(worry, 3) end
    play_keep_away(args, 20, worry_management)
  end

  def part2(args) do
    common_multiple = get_monkeys_common_multiple(args)
    worry_management = fn worry -> rem(worry, common_multiple) end
    play_keep_away(args, 10000, worry_management)
  end

  defp play_keep_away(args, rounds, worry_management) do
    {initial_items, initial_inspections, operations, rules} =
      args
      |> String.split("\n\n", trim: true)
      |> Enum.map(&parse_block/1)
      |> Enum.reduce({%{}, %{}, %{}, %{}}, fn {monkey, items, operations, rules},
                                              {all_items, all_inspections, all_operations,
                                               all_rules} ->
        {
          all_items |> Map.put(monkey, items),
          all_inspections |> Map.put(monkey, 0),
          all_operations |> Map.put(monkey, operations),
          all_rules |> Map.put(monkey, rules)
        }
      end)

    1..rounds
    |> Enum.reduce({initial_items, initial_inspections}, fn _, {items, inspections} ->
      play_keep_away_round(items, inspections, operations, rules, worry_management)
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.split(2)
    |> elem(0)
    |> Enum.product()
  end

  defp play_keep_away_round(items, inspections, operations, rules, worry_management) do
    0..(map_size(items) - 1)
    |> Enum.reduce({items, inspections}, fn monkey, {current_items, current_inspections} ->
      current_items[monkey]
      |> Enum.reduce({current_items, current_inspections}, fn worry_level,
                                                              {new_items, new_inspections} ->
        new_worry_level = operations[monkey].(worry_level) |> worry_management.()
        next_monkey = rules[monkey].(new_worry_level)

        {
          new_items
          |> Map.put(next_monkey, new_items[next_monkey] ++ [new_worry_level])
          |> Map.put(monkey, new_items[monkey] |> tl()),
          new_inspections
          |> Map.put(monkey, new_inspections[monkey] + 1)
        }
      end)
    end)
  end

  defp get_monkeys_common_multiple(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line -> String.contains?(line, "divisible") end)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn "Test: divisible by " <> line -> String.to_integer(line) end)
    |> Enum.product()
  end

  defp parse_block(block) do
    [monkey, items, operation | test] =
      block
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    {parse(monkey), parse(items), parse(operation), parse(test)}
  end

  defp parse("Monkey " <> monkey) do
    monkey
    |> String.replace(":", "")
    |> String.to_integer()
  end

  defp parse("Starting items: " <> items) do
    String.split(items, ", ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse("Operation: new = " <> operation) do
    fn old -> Code.eval_string(operation, old: old) |> elem(0) end
  end

  defp parse(test) when is_list(test) do
    [divider, monkey_true, monkey_false] =
      test
      |> Enum.map(fn line ->
        String.split(line, " ", trim: true)
        |> Enum.reverse()
        |> hd()
        |> String.to_integer()
      end)

    fn worry -> if rem(worry, divider) == 0, do: monkey_true, else: monkey_false end
  end
end
