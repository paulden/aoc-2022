defmodule AdventOfCode.Day07 do
  def part1(args) do
    filesystem = build_filesystem(args)

    filesystem
    |> Enum.map(fn {directory, _} ->
      compute_directory_size(directory, filesystem, 0)
    end)
    |> Enum.filter(fn size -> size < 100_000 end)
    |> Enum.sum()
  end

  def part2(args) do
    filesystem = build_filesystem(args)
    total_space_occupied = compute_directory_size("root", filesystem, 0)
    unused_space = 70_000_000 - total_space_occupied
    free_space_needed = 30_000_000 - unused_space

    filesystem
    |> Enum.map(fn {directory, _} ->
      compute_directory_size(directory, filesystem, 0)
    end)
    |> Enum.filter(fn size -> size >= free_space_needed end)
    |> Enum.min()
  end

  defp build_filesystem(args) do
    {_, filesystem} =
      args
      |> String.split("\n", trim: true)
      |> Enum.reduce({"", %{}}, fn current, acc ->
        {pwd, current_fs} = acc

        cond do
          String.contains?(current, "$ cd") -> {pwd |> go_to(current), current_fs}
          String.contains?(current, "$ ls") -> acc
          not String.contains?(current, "$") -> {pwd, current_fs |> add_item_to_fs(pwd, current)}
        end
      end)

    filesystem
  end

  defp compute_directory_size(directory, filesystem, current_size) do
    filesystem[directory]
    |> Enum.map(fn item ->
      if String.contains?(item, " ") do
        item_size =
          item
          |> String.split(" ")
          |> hd()
          |> String.to_integer()

        item_size + current_size
      else
        compute_directory_size(item, filesystem, current_size)
      end
    end)
    |> Enum.sum()
  end

  defp go_to(pwd, command) do
    destination =
      command
      |> String.split("$ cd ", trim: true)
      |> List.first()

    case destination do
      "/" -> "root"
      ".." -> pwd |> go_back()
      _ -> "#{pwd}/#{destination}"
    end
  end

  defp go_back(pwd) do
    pwd
    |> String.split("/", trim: true)
    |> Enum.reverse()
    |> tl()
    |> Enum.reverse()
    |> Enum.join("/")
  end

  defp add_item_to_fs(current_fs, pwd, current) do
    if is_nil(current_fs[pwd]) do
      current_fs
      |> Map.put(pwd, [get_item_from_line(current, pwd)])
    else
      current_fs
      |> Map.put(pwd, [get_item_from_line(current, pwd) | current_fs[pwd]])
    end
  end

  defp get_item_from_line(line, pwd) do
    if String.contains?(line, "dir") do
      dir =
        line
        |> String.split(" ")
        |> Enum.reverse()
        |> hd()

      "#{pwd}/#{dir}"
    else
      line
    end
  end
end
