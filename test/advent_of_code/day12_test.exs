defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "day12.part1" do
    input = """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """

    result = part1(input)

    assert result == 31
  end

  test "day12.part2" do
    input = """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """

    result = part2(input)

    assert result == 29
  end
end
