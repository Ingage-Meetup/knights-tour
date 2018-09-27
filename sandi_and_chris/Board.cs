using System;
using System.Collections.Generic;
using System.Linq;

namespace KnightsTour
{
    public class Board
    {
        private readonly int _dimensions;

        private readonly bool[,] _square;
        private int _visitedCount;

        private static readonly Point[] _moves = new Point[]
        {
            new Point(-1, -2),
            new Point(+1, -2),
            new Point(-2, -1),
            new Point(+2, -1),
            new Point(-1, +2),
            new Point(+1, +2),
            new Point(-2, +1),
            new Point(+2, +1)
        };

        public Board(int dimensions = 8)
        {
            _dimensions = dimensions;

            _square = new bool[dimensions, dimensions];
            _visitedCount = 0;
        }

        public bool IsVisited(int x, int y)
        {
            return _square[x, y];
        }

        public void SetVisited(int x, int y, bool visited)
        {
            if (_square[x, y] != visited)
            {
                _square[x, y] = visited;
                _visitedCount += (visited) ? 1 : -1;
            }
        }

        public bool VisitedEverySpot()
        {
            return _visitedCount == (_dimensions * _dimensions);
        }

        public bool IsInBounds(int x, int y)
        {
            if (x >= 0 && x < _dimensions && y >= 0 && y < _dimensions)
                return true;

            return false;
        }

#if false
        public List<Point> GetDestinations(int x, int y)
        {
            List<Point> destinations = new List<Point>(8);
            foreach (Point p in _moves)
            {
                int xx = x + p.X;
                int yy = y + p.Y;

                if (!IsInBounds(xx, yy))
                    continue;        // out of bounds

                if (IsVisited(xx, yy))
                    continue;       // already visited, can't revisit

                destinations.Add(new Point(xx, yy));
            }

            return destinations;
        }
#endif

#if true
        public IEnumerable<Point> GetDestinations(int x, int y)
        {
            foreach (Point p in _moves)
            {
                int xx = x + p.X;
                int yy = y + p.Y;

                if (!IsInBounds(xx, yy))
                    continue;        // out of bounds

                if (IsVisited(xx, yy))
                    continue;       // already visited, can't revisit

                yield return new Point(xx, yy);
            }
        }
#endif

        public bool IsUnsolvable(int x, int y)
        {
            if (IsInBounds(x, y))
            {
                // System.Diagnostics.Debug.Assert(IsVisited(x, y));
                foreach (Point dest in this.GetDestinations(x, y))
                {
                    int num = this.GetDestinations(dest.X, dest.Y).Count();
                    return num == 0;
                }
            }

            return false;
        }
    }
}
