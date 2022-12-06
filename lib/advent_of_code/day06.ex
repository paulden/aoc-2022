defmodule AdventOfCode.Day06 do
  @start_of_packet_marker_size 4
  @start_of_message_marker_size 14

  def part1(args) do
    find_marker_for_size(args, @start_of_packet_marker_size)
  end

  def part2(args) do
    find_marker_for_size(args, @start_of_message_marker_size)
  end

  defp find_marker_for_size(args, size) do
    args
    |> String.split("", trim: true)
    |> Enum.reduce_while([], fn character, buffer_so_far ->
      buffer_so_far = [character | buffer_so_far]

      unique_characters_numbers =
        buffer_so_far
        |> Enum.chunk_every(size)
        |> List.first()
        |> Enum.uniq()
        |> length()

      if unique_characters_numbers == size do
        {:halt, buffer_so_far}
      else
        {:cont, buffer_so_far}
      end
    end)
    |> length()
  end
end
