defmodule KnightsTour do

  @grid %{
    0 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    1 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    2 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    3 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    4 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    5 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    6 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 },
    7 => %{ 0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0 }
  }

  @moves [
    {2, 1},
    {1, 2},
    {-1, 2},
    {-2, 1},
    {-2, -1},
    {-1, -2},
    {1, -2},
    {2, -1}
  ]

  @x_move [2, 1, -1, -2, -2, -1, 1, 2]
  @y_move [1, 2, 2, 1, -1, -2, -2, -1]

  def begin() do
    {grid, move_number} = move(@grid, {4, 4}, 1)
    next(grid, {4, 4}, move_number + 1)
  end

  def next(grid, {x, y} = current_pos,  move_number) do
    IO.puts("CURRENT ITERATION + #{move_number}")
    IO.inspect grid
    if (move_number == 64) do
      IO.puts("SOLVED!")
    else
      # check each valid move and it's accessiblity
      # move to the next space with lowest accessibilty
      next_moves = Enum.map(@moves, fn({nx, ny}) ->
        {xx, yy} = {x + nx, y + ny}
        if (out_of_bounds({xx, yy}, grid )) do
          {xx, yy, 0}
        else
          n = number_accessible({xx, yy}, grid)
          {xx, yy, n}
        end
      end)

      IO.inspect next_moves

      if (move_number == 63) do
        {e, f, g} = Enum.find(next_moves, fn {a, b, c} -> !out_of_bounds({a,b}, grid) end)
        {grid, move_number} = move(grid, {e, f}, move_number + 1)
        next(grid, {e, f}, move_number)
      else
        { next_x, next_y, _ } =
          next_moves
          |> Enum.filter(fn {xx, yy, n} -> n > 0 end)
          |> Enum.reduce(fn ({xx, yy, n} = curr, {xx1, yy1, n1} = acc) ->
            if n < n1 do
              curr
            else
              acc
            end
          end)
        {grid, move_number} = move(grid, {next_x, next_y}, move_number + 1)
        next(grid, {next_x, next_y}, move_number)
      end
    end
  end

  def move(grid, {x, y}, move_number) do
    {put_in(grid[x][y], 1), move_number}
  end

  def is_visited({x, y}, grid) do
    grid[x][y] == 1
  end

  def number_accessible({x, y}, grid) do
    @moves
    |> Enum.map(fn {nx, ny} -> {nx + x, ny + y} end)
    |> Enum.reduce(0, fn {a,b}, acc ->
      if (out_of_bounds({a,b}, grid)) do
        acc
      else
        acc + 1
      end
    end)
  end


  def out_of_bounds({xx, yy}, grid) do
    (xx > 7 || xx < 0) || (yy > 7 || yy < 0)  || is_visited({xx, yy}, grid)
  end

end
