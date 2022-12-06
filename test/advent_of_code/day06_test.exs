defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "day06.part1_0" do
    input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

    result = part1(input)

    assert result == 7
  end

  test "day06.part1_1" do
    input = "bvwbjplbgvbhsrlpgdmjqwftvncz"

    result = part1(input)

    assert result == 5
  end

  test "day06.part1_2" do
    input = "nppdvjthqldpwncqszvftbrmjlhg"

    result = part1(input)

    assert result == 6
  end

  test "day06.part1_3" do
    input = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"

    result = part1(input)

    assert result == 10
  end

  test "day06.part1_4" do
    input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

    result = part1(input)

    assert result == 11
  end

  test "day06.part2_0" do
    input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"

    result = part2(input)

    assert result == 19
  end

  test "day06.part2_1" do
    input = "bvwbjplbgvbhsrlpgdmjqwftvncz"

    result = part2(input)

    assert result == 23
  end

  test "day06.part2_2" do
    input = "nppdvjthqldpwncqszvftbrmjlhg"

    result = part2(input)

    assert result == 23
  end

  test "day06.part2_3" do
    input = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"

    result = part2(input)

    assert result == 29
  end

  test "day06.part2_4" do
    input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"

    result = part2(input)

    assert result == 26
  end
end
