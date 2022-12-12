defmodule AdventOfCode.Day12 do
  def part1(args) do
    parsed_map =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&:binary.bin_to_list/1)

    length = length(parsed_map)
    width = length(hd(parsed_map))

    <<starting_point>> = "S"
    <<ending_point>> = "E"

    {start_row, start_y} =
      parsed_map
      |> Enum.with_index()
      |> Enum.filter(fn {line, _} -> line |> Enum.member?(starting_point) end)
      |> hd()

    {_, start_x} =
      start_row
      |> Enum.with_index()
      |> Enum.find(fn {char, _} -> char == starting_point end)

    {end_row, end_y} =
      parsed_map
      |> Enum.with_index()
      |> Enum.filter(fn {line, _} -> line |> Enum.member?(ending_point) end)
      |> hd()

    {_, end_x} =
      end_row
      |> Enum.with_index()
      |> Enum.find(fn {char, _} -> char == ending_point end)

    after_replace =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> line |> String.replace("S", "a") |> String.replace("E", "z") end)
      |> Enum.map(&:binary.bin_to_list/1)

    graph =
      after_replace
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
              neighbor_value = after_replace |> Enum.at(j) |> Enum.at(i)
              neighbor_value <= char + 1
            end)

          g |> Map.put({x, y}, neighbors)
        end)
      end)

    target = {end_x, end_y}
    queue = graph[{start_x, start_y}]
    explored = %{{0, 0} => 0}
    neighbors = []

    bfs(explored, graph, queue, neighbors, 1)
    |> Map.get(target)
  end

  defp bfs(explored, _, [], [], _), do: explored

  defp bfs(explored, graph, [], neighbors, steps) do
    bfs(explored, graph, neighbors, [], steps + 1)
  end

  defp bfs(explored, graph, [current_point | tail], neighbors, steps) do
    if Map.has_key?(explored, current_point) do
      bfs(explored, graph, tail, neighbors, steps)
    else
      explored
      |> Map.put(current_point, steps)
      |> bfs(graph, tail, graph[current_point] ++ neighbors, steps)
    end
  end

  def part2(args) do
    parsed_map =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&:binary.bin_to_list/1)

    length = length(parsed_map)
    width = length(hd(parsed_map))

    <<ending_point>> = "E"

    {end_row, end_y} =
      parsed_map
      |> Enum.with_index()
      |> Enum.filter(fn {line, _} -> line |> Enum.member?(ending_point) end)
      |> hd()

    {_, end_x} =
      end_row
      |> Enum.with_index()
      |> Enum.find(fn {char, _} -> char == ending_point end)


    after_replace =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> line |> String.replace("S", "a") |> String.replace("E", "z") end)
      |> Enum.map(&:binary.bin_to_list/1)

    graph =
      after_replace
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
              neighbor_value = after_replace |> Enum.at(j) |> Enum.at(i)
              neighbor_value <= char + 1
            end)

          g |> Map.put({x, y}, neighbors)
        end)
      end)

    target = {end_x, end_y}
    explored = %{{0, 0} => 0}
    neighbors = []

    after_replace
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.reduce([], fn {char, index}, potential_starting_points ->
      if char == ?a do
        [{rem(index, width), div(index, width)} | potential_starting_points]
      else
        potential_starting_points
      end
    end)
    |> Enum.map(fn start_point ->
      bfs(explored, graph, graph[start_point], neighbors, 1)
      |> Map.get(target)
    end)
    |> Enum.min()
  end
end
