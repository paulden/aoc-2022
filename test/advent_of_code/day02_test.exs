defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "day02.part1" do
    input = """
    A Y
    B X
    C Z
    """

    result = part1(input)

    assert result == 15
  end

  test "day02.part2" do
    input = """
    A Y
    B X
    C Z
    """

    result = part2(input)

    assert result == 12
  end
end