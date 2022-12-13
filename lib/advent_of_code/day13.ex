defmodule AdventOfCode.Day13 do
  def part1(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pair/1)
    |> Enum.with_index(1)
    |> Enum.filter(fn {pair, _} -> are_right_order(pair) end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Kernel.++(["[[2]]", "[[6]]"])
    |> Enum.map(&Code.eval_string/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort(&are_right_order/2)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _} -> packet == [[2]] or packet == [[6]] end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  defp parse_pair(pair) do
    pair
    |> String.split("\n", trim: true)
    |> Enum.map(&Code.eval_string/1)
    |> Enum.map(&elem(&1, 0))
  end

  defp are_right_order([l, r]), do: are_right_order(l, r)
  defp are_right_order({l, r}), do: are_right_order(l, r)

  defp are_right_order(left, right) when is_integer(left) and is_integer(right) do
    cond do
      left < right -> true
      left > right -> false
      left == right -> :undefined
    end
  end

  defp are_right_order(left, right) when is_integer(left) and is_list(right) do
    are_right_order([left], right)
  end

  defp are_right_order(left, right) when is_list(left) and is_integer(right) do
    are_right_order(left, [right])
  end

  defp are_right_order(left, right) when is_list(left) and is_list(right) do
    list_comparisons =
      [left, right]
      |> Enum.zip()
      |> Enum.map(&are_right_order/1)
      |> Enum.reject(fn result -> result == :undefined end)

    if length(list_comparisons) == 0 do
      cond do
        length(left) < length(right) -> true
        length(left) > length(right) -> false
        length(left) == length(right) -> :undefined
      end
    else
      hd(list_comparisons)
    end
  end
end
