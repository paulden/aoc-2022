defmodule AdventOfCode.Day12 do
  def part1(args) do
    start = args |> find_coordinates("S")
    target = args |> find_coordinates("E")

    map = parse_map(args)
    graph = build_graph(map)

    # Queue of points to visit at each step
    queue = graph[start]
    # Already explored points with number of steps to reach from the start
    steps_to_visited = %{{0, 0} => 0}
    # Next batch of neighbors to visit once all points in current step have been visited
    neighbors = []

    bfs(steps_to_visited, graph, queue, neighbors, 1)
    |> Map.get(target)
  end

  def part2(args) do
    starts = [find_coordinates(args, "S") | find_all_coordinates(args, "a")]
    target = find_coordinates(args, "E")

    map = parse_map(args)
    graph = build_graph(map)

    steps_to_visited = %{{0, 0} => 0}
    neighbors = []

    starts
    |> Enum.map(fn start_point ->
      bfs(steps_to_visited, graph, graph[start_point], neighbors, 1)
      |> Map.get(target)
    end)
    |> Enum.min()
  end

  defp bfs(steps_to_visited, graph, [current_point | tail], neighbors, steps) do
    if Map.has_key?(steps_to_visited, current_point) do
      # We have already visited this point, removing from queue
      bfs(steps_to_visited, graph, tail, neighbors, steps)
    else
      # Adding the current point visited after X steps
      updated_steps_to_visited = Map.put(steps_to_visited, current_point, steps)
      # We keep exploring the remaining tail of the queue at X steps, while adding potential neighbors from current point
      bfs(updated_steps_to_visited, graph, tail, graph[current_point] ++ neighbors, steps)
    end
  end

  defp bfs(steps_to_visited, _, [], [], _) do
    # Nothing to visit any longer, returning results
    steps_to_visited
  end

  defp bfs(steps_to_visited, graph, [], neighbors, steps) do
    # The queue of points to visit is empty, visiting next neighbors at steps + 1
    bfs(steps_to_visited, graph, neighbors, [], steps + 1)
  end

  defp find_coordinates(args, to_find) do
    input = String.split(args, "\n", trim: true)

    width = String.length(hd(input))

    index =
      input
      |> Enum.join("")
      |> String.split("", trim: true)
      |> Enum.find_index(fn char -> char == to_find end)

    {rem(index, width), div(index, width)}
  end

  defp find_all_coordinates(args, to_find) do
    input = String.split(args, "\n", trim: true)

    width = String.length(hd(input))

    input
    |> Enum.join("")
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce([], fn {char, index}, coordinates ->
      if char == to_find do
        [{rem(index, width), div(index, width)} | coordinates]
      else
        coordinates
      end
    end)
  end

  defp parse_map(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.replace("S", "a")
      |> String.replace("E", "z")
    end)
    |> Enum.map(&:binary.bin_to_list/1)
  end

  defp build_graph(map) do
    length = length(map)
    width = length(hd(map))

    map
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, current_graph ->
      line
      |> Enum.with_index()
      |> Enum.reduce(current_graph, fn {char, x}, g ->
        neighbors =
          [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
          |> Enum.map(fn {i, j} -> {x + i, y + j} end)
          |> Enum.filter(fn {i, j} ->
            i >= 0 and i < width and j >= 0 and j < length
          end)
          |> Enum.filter(fn {i, j} ->
            neighbor_value = map |> Enum.at(j) |> Enum.at(i)
            neighbor_value <= char + 1
          end)

        g |> Map.put({x, y}, neighbors)
      end)
    end)
  end
end
