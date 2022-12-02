defmodule AdventOfCode.Day02 do
  @opponent_code %{"A" => :rock, "B" => :paper, "C" => :scissors}
  @losing_options %{:paper => :rock, :scissors => :paper, :rock => :scissors}
  @winning_options %{:rock => :paper, :paper => :scissors, :scissors => :rock}
  @shape_points %{:rock => 1, :paper => 2, :scissors => 3}

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&get_moves_part1/1)
    |> Enum.map(&get_round_points/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&get_moves_part2/1)
    |> Enum.map(&get_round_points/1)
    |> Enum.sum()
  end

  defp get_moves_part1(round) do
    own_code = %{"X" => :rock, "Y" => :paper, "Z" => :scissors}
    [opponent, own] = String.split(round, " ")
    {@opponent_code[opponent], own_code[own]}
  end

  defp get_moves_part2(round) do
    [opponent, own_strategy] = String.split(round, " ")
    p1 = @opponent_code[opponent]

    p2 =
      cond do
        own_strategy == "X" -> @losing_options[p1]
        own_strategy == "Y" -> p1
        own_strategy == "Z" -> @winning_options[p1]
      end

    {p1, p2}
  end

  defp get_round_points({p1, p2}) do
    cond do
      p1 == p2 -> 3 + @shape_points[p2]
      @losing_options[p1] == p2 -> @shape_points[p2]
      @winning_options[p1] == p2 -> 6 + @shape_points[p2]
    end
  end
end
