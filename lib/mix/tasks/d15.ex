defmodule Mix.Tasks.D15 do
  use Mix.Task

  import AdventOfCode.Day15

  @shortdoc "Day 15"
  def run(_) do
    input()
    |> part1(2000000)
    |> IO.inspect(label: "Part 1 Results")


    input()
    |> part2()
    |> IO.inspect(label: "Part 2 Results")
  end

  defp input do
    """
    Sensor at x=3291456, y=3143280: closest beacon is at x=3008934, y=2768339
    Sensor at x=3807352, y=3409566: closest beacon is at x=3730410, y=3774311
    Sensor at x=1953670, y=1674873: closest beacon is at x=2528182, y=2000000
    Sensor at x=2820269, y=2810878: closest beacon is at x=2796608, y=2942369
    Sensor at x=3773264, y=3992829: closest beacon is at x=3730410, y=3774311
    Sensor at x=2913793, y=2629579: closest beacon is at x=3008934, y=2768339
    Sensor at x=1224826, y=2484735: closest beacon is at x=2528182, y=2000000
    Sensor at x=1866102, y=3047750: closest beacon is at x=1809319, y=3712572
    Sensor at x=3123635, y=118421: closest beacon is at x=1453587, y=-207584
    Sensor at x=2530789, y=2254773: closest beacon is at x=2528182, y=2000000
    Sensor at x=230755, y=3415342: closest beacon is at x=1809319, y=3712572
    Sensor at x=846048, y=51145: closest beacon is at x=1453587, y=-207584
    Sensor at x=3505756, y=3999126: closest beacon is at x=3730410, y=3774311
    Sensor at x=2506301, y=3745758: closest beacon is at x=1809319, y=3712572
    Sensor at x=1389843, y=957209: closest beacon is at x=1453587, y=-207584
    Sensor at x=3226352, y=3670258: closest beacon is at x=3730410, y=3774311
    Sensor at x=3902053, y=3680654: closest beacon is at x=3730410, y=3774311
    Sensor at x=2573020, y=3217129: closest beacon is at x=2796608, y=2942369
    Sensor at x=3976945, y=3871511: closest beacon is at x=3730410, y=3774311
    Sensor at x=107050, y=209321: closest beacon is at x=1453587, y=-207584
    Sensor at x=3931251, y=1787536: closest beacon is at x=2528182, y=2000000
    Sensor at x=1637093, y=3976664: closest beacon is at x=1809319, y=3712572
    Sensor at x=2881987, y=1923522: closest beacon is at x=2528182, y=2000000
    Sensor at x=3059723, y=2540501: closest beacon is at x=3008934, y=2768339
    """
  end
end
