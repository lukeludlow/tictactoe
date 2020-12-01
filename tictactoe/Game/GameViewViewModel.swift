//
//  GameViewViewModel.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-27.
//

import Foundation
import Combine

class GameViewViewModel: ObservableObject {
    @Published var cells: [[Cell]] = []
    @Published var currentPlayerTurn: String
    @Published var playerOne: String
    @Published var playerTwo: String
    @Published var isComplete: Bool
    @Published var winner: String

    var session: SessionStore
    var database: FirebaseDatabaseStore


    init(playerOne: String, playerTwo: String, session: SessionStore, database: FirebaseDatabaseStore) {
        print("init")
        self.cells = [
            [Cell(row: 0, col: 0, value: XO.empty), Cell(row: 0, col: 1, value: XO.empty), Cell(row: 0, col: 2, value: XO.empty)],
            [Cell(row: 1, col: 0, value: XO.empty), Cell(row: 1, col: 1, value: XO.empty), Cell(row: 1, col: 2, value: XO.empty)],
            [Cell(row: 2, col: 0, value: XO.empty), Cell(row: 2, col: 1, value: XO.empty), Cell(row: 2, col: 2, value: XO.empty)]
        ]
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.currentPlayerTurn = playerOne
        self.isComplete = false
        self.winner = ""
        self.session = session
        self.database = database
    }
    
//    func incrementPlayerWins() {
//        print("increment player wins")
//        for player in self.database.players {
//            if player.uid == self.session.session?.uid {
//                player.wins += 1
//                player.ref?.updateChildValues(["wins": player.wins])
//            }
//        }
//    }
    
    func tick() {
        self.winner = detectWinner()
        if self.winner != "" {
            print("game over, \(self.winner) won")
//            if winner == playerOne {
//                incrementPlayerWins()
//            } else if winner == playerTwo {
                // decrementPlayerWins()
//            }
            self.isComplete = true
            return
        }
        if !anyEmptyCells() {
            print("game over, no empty cells")
            if self.winner == "" {
                self.winner = "nobody"
            }
            self.isComplete = true
            return
        }
        if currentPlayerTurn == "CPU" && !isComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.cpuMakeMove()
            })
        }
    }
    
    func detectWinner() -> String {
        // check for horizontal three in a row
        for row in cells {
            if row.allSatisfy({ $0.value == XO.x }) {
                return playerOne
            } else if row.allSatisfy({ $0.value == XO.o }) {
                return playerTwo
            }
        }
        // check for vertical three in a row
        for i in 0...2 {
            if cells.allSatisfy({ $0[i].value == XO.x }) {
                return playerOne
            } else if cells.allSatisfy({ $0[i].value == XO.o }) {
                return playerTwo
            }
        }
        // check for diagonal three in a row
        let diagonalPermutations: [[(Int, Int)]] = [
            [(0, 0), (1, 1), (2, 2)],
            [(2, 0), (1, 1), (0, 2)]
        ]
        for diagonal in diagonalPermutations {
            if diagonal.allSatisfy({ cells[$0.0][$0.1].value == XO.x }) {
                return playerOne
            } else if diagonal.allSatisfy({ cells[$0.0][$0.1].value == XO.o }) {
                return playerTwo
            }
        }
        return ""
    }
    
    func toggleCell(cell: Cell) {
        print("toggleCell. cell.row=\(cell.row), cell.col=\(cell.col), currentPlayerTurn=\(currentPlayerTurn)")
        if currentPlayerTurn == playerOne {
            self.cells[cell.row][cell.col].value = XO.x
            currentPlayerTurn = playerTwo
        } else {
            self.cells[cell.row][cell.col].value = XO.o
            currentPlayerTurn = playerOne
        }
        tick()
    }
    
    func cpuMakeMove() {
        if (anyEmptyCells() && currentPlayerTurn == "CPU") {
            print("cpu make move")
            let emptyCells = self.cells.flatMap({ $0 }).filter { $0.value == XO.empty }
            let cellToChange = emptyCells.randomElement()!
            print("cpu chose cell at \(cellToChange.row),\(cellToChange.col)")
            self.cells[cellToChange.row][cellToChange.col].value = XO.o
            currentPlayerTurn = playerOne
        }
        tick()
    }
    
    func anyEmptyCells() -> Bool {
        let emptyCells = self.cells.flatMap({ $0 }).filter { $0.value == XO.empty }
        return emptyCells.count > 0
    }
}
