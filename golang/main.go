package main

import (
	"fmt"
	"time"
)

const boardSize = 8
const startX = 0
const startY = 0
const maxNodesVisited = boardSize * boardSize

var visited = 0

type move struct {
	x int
	y int
}

var moves = []move{
	{x: 2, y: 1},
	{x: 1, y: 2},
	{x: 2, y: -1},
	{x: 1, y: -2},
	{x: -2, y: 1},
	{x: -1, y: 2},
	{x: -2, y: -1},
	{x: -1, y: -2},
}

// var board [][]bool
func main() {
	start := time.Now()

	board := [boardSize][boardSize]bool{}
	solution, solved := visitSpace(board, startX, startY)
	fmt.Printf("solved = %t\n", solved)
	if solved {
		for _, space := range solution {
			fmt.Printf("space %d,%d\n", space.x, space.y)
		}
	}

	elapsed := time.Since(start)
	fmt.Printf("Took %s", elapsed)
}

func visitSpace(board [boardSize][boardSize]bool, x int, y int) ([]move, bool) {
	//fmt.Printf("Visiting [%d][%d]\n", x, y)
	if allVisited(board) {
	//if allVisitedBruteForce(board) {
		return nil, true
	}

	if x < 0 || x >= boardSize {
		// space isn't valid
		return nil, false
	}

	if y < 0 || y >= boardSize {
		// space isn't valid
		return nil, false
	}

	if board[x][y] == true {
		return nil, false
	}

	board[x][y] = true
	visited++

	for _, step := range moves {
		result, success := visitSpace(board, x+step.x, y+step.y)
		if success {
			validMove := move{x: x, y: y}
			result = append([]move{validMove}, result...)
			return result, true
		}
	}

	visited--
	board[x][y] = false

	return nil, false
}

func allVisited(board [boardSize][boardSize]bool) bool {
	return visited == maxNodesVisited
}

func allVisitedBruteForce(board [boardSize][boardSize]bool) bool {
	for x := 0; x < boardSize; x++ {
		for y := 0; y < boardSize; y++ {
			if board[x][y] == false {
				return false
			}
		}
	}
	return true
}
