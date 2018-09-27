using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace KnightsTour
{
    class Program
    {
        static int _totalMoves = 0;

        static void Main(string[] args)
        {
            Board board = new Board(5);
            List<Point> solution = new List<Point>();

            Stopwatch stopwatch = new Stopwatch();
            stopwatch.Start();

            if (Move(board, solution, 0, 0))
            {
                Console.WriteLine("Found a solution:");
                for (int i = 0; i < solution.Count; ++i)
                {
                    var spot = solution[i];
                    Console.WriteLine($"{i+1}: {spot.X}, {spot.Y}");
                }
            }
            else
            {
                Console.WriteLine("No solution");
            }

            Console.WriteLine($"Time = {stopwatch.Elapsed.TotalSeconds} seconds");
            Console.WriteLine($"Total moves = {_totalMoves}");
        }

        static bool Move(Board board, List<Point> solution, int x, int y, int oldX = -1, int oldY = -1)
        {
            _totalMoves += 1;

            board.SetVisited(x, y, true);

            if (board.VisitedEverySpot())
            {
                solution.Insert(0, new Point(x, y));
                return true;        // success, done
            }

            if (!board.IsUnsolvable(oldX, oldY))
            {
                foreach (Point dest in board.GetDestinations(x, y))
                {
                    if (Move(board, solution, dest.X, dest.Y, x, y))
                    {
                        solution.Insert(0, new Point(x, y));
                        return true;
                    }
                }
            }

            board.SetVisited(x, y, false);

            return false;
        }
    }
}
