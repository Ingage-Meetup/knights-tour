using System;
using System.Collections.Generic;
					
namespace KnightsTour
{
   public class Program
   {
       private static int sideLength { get; set; }

	   private struct Coordinates
	   {
			public int x;
			public int y;
	   }
	   
	   // Calculate (x,y) coordinates based on square number
	   private static Coordinates calcCoordinates(int squareNum)
	   {
			Coordinates coordinates = new Coordinates();
			coordinates.x = squareNum % sideLength;
		   	if (coordinates.x == 0 ) { coordinates.x = sideLength; }
            coordinates.y = (squareNum+sideLength-1) / sideLength;
		   
		   return coordinates;
	   }
	   
	   // Calculate the square number based on (x,y) coordinates
	   private static int calcSquare(int x, int y)
	   {
		   if (x<1 || x > sideLength || y<1 || y > sideLength) { return -1; }
		   else { return ((y-1)*sideLength+x); }
	   }
	   
       public static void Main(string[] args)
       {
           sideLength = 5;
		   int startSeq = 1;
		   int endSeq = startSeq;
		   //endSeq = sideLength*sideLength; // Switch if you want to calculate all iterations (but I wouldn't do it for sideLength of 8)
		   PrintBoard(sideLength);
		   
           for (int startingSquare=startSeq; startingSquare<= endSeq; startingSquare++) {
			 	List<int> tour = new List<int>();
				TakeTour(tour, startingSquare, 0);
		   }
		   Console.WriteLine("Finished.");

	   }

       public static bool TakeTour(List<int> incomingTour, int nextSquare, int ruleNum)
       {
		   List<int> currentTour= new List<int>(incomingTour);
		   
		   // Check if out-of-bounds
           if (nextSquare < 1 || nextSquare > sideLength * sideLength) { return false; }

		   // Check if already visited
           if (currentTour.Contains(nextSquare)) { return false; }

		   // Valid move, so add to list
           currentTour.Add(nextSquare);
		   
		   // Check if you have a winner
           if (currentTour.Count == sideLength * sideLength)
           {
               PrintTour(currentTour);
			   return true;
           }
           else
           {
			   Coordinates curr = calcCoordinates(nextSquare);
			   bool solutionFound = false;
               solutionFound = TakeTour(currentTour, calcSquare(curr.x-1, curr.y-2), 1); // Up 2 and Left 1
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x+1, curr.y-2), 2);}; // Up 2 and Right 1
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x-2, curr.y-1), 3);}; // Up 1 and Left 2
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x+2, curr.y-1), 4);}; // Up 1 and Right 2
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x-2, curr.y+1), 5);}; // Down 1 and Left 2
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x+2, curr.y+1), 6);}; // Down 1 and Right 2
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x-1, curr.y+2), 7);}; // Down 2 and Left 1
               if(!solutionFound) {solutionFound = TakeTour(currentTour, calcSquare(curr.x+1, curr.y+2), 8);}; // Down 2 and Right 1
			   
			   return solutionFound;
           }
       }
	   
       public static void PrintTour(List<int> tour)
       {
           Console.WriteLine(String.Join(", ", tour));
       }
	   
	   public static void PrintBoard(int boardWidth)
	   {
		   Console.WriteLine("*** Game Board ***");
			for (int i = 1; i <= (boardWidth*boardWidth); i++){
				Console.Write(i.ToString().PadLeft(3));
				if (i%boardWidth == 0) { Console.WriteLine(); } // New Line
			}
		   Console.WriteLine();
	   }
   }
}