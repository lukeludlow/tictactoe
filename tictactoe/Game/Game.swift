//
//  TicTacToeGame.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import Foundation
import FirebaseDatabase

class Game: Identifiable, ObservableObject {
   
    @Published var ref: DatabaseReference?
    @Published var uid: String
    @Published var playerOne: String
    @Published var playerTwo: String
    @Published var isComplete: Bool
    @Published var currentPlayerTurn: String
    @Published var winner: String
    @Published var cells: [Cell]
    
    init(playerOne: String, playerTwo: String) {
        self.ref = nil
        self.uid = UUID().uuidString
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.isComplete = false
        self.currentPlayerTurn = playerOne
        self.winner = ""
        self.cells = [
            Cell(row: 0, col: 0, value: XO.empty), Cell(row: 0, col: 1, value: XO.empty), Cell(row: 0, col: 2, value: XO.empty),
            Cell(row: 1, col: 0, value: XO.empty), Cell(row: 1, col: 1, value: XO.empty), Cell(row: 1, col: 2, value: XO.empty),
            Cell(row: 2, col: 0, value: XO.empty), Cell(row: 2, col: 1, value: XO.empty), Cell(row: 2, col: 2, value: XO.empty)
        ]
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let uid = value["uid"] as? String,
            let playerOne = value["playerOne"] as? String,
            let playerTwo = value["playerTwo"] as? String,
            let isComplete = value["isComplete"] as? Bool,
            let currentPlayerTurn = value["currentPlayerTurn"] as? String,
            let winner = value["winner"] as? String,
            let observedCells = value["cells"] as? NSArray
            else {
                return nil
            }
        self.ref = snapshot.ref
        self.uid = uid
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.isComplete = isComplete
        self.currentPlayerTurn = currentPlayerTurn
        self.winner = winner
        let cells = (observedCells as Array<AnyObject>).compactMap{ Cell(anyObject: $0) }
        self.cells = cells
    }
    
    init() {
        self.ref = nil
        self.uid = UUID().uuidString
        self.playerOne = ""
        self.playerTwo = ""
        self.isComplete = false
        self.currentPlayerTurn = ""
        self.winner = ""
        self.cells = [
            Cell(row: 0, col: 0, value: XO.empty), Cell(row: 0, col: 1, value: XO.empty), Cell(row: 0, col: 2, value: XO.empty),
            Cell(row: 1, col: 0, value: XO.empty), Cell(row: 1, col: 1, value: XO.empty), Cell(row: 1, col: 2, value: XO.empty),
            Cell(row: 2, col: 0, value: XO.empty), Cell(row: 2, col: 1, value: XO.empty), Cell(row: 2, col: 2, value: XO.empty)
        ]
    }
    
    func copyFrom(otherGame: Game) {
        print("copying game state")
        self.ref = otherGame.ref
        self.uid = otherGame.uid
        self.playerOne = otherGame.playerOne
        self.playerTwo = otherGame.playerTwo
        self.isComplete = otherGame.isComplete
        self.currentPlayerTurn = otherGame.currentPlayerTurn
        self.winner = otherGame.winner
        self.cells = otherGame.cells
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "playerOne": playerOne,
            "playerTwo": playerTwo,
            "isComplete": isComplete,
            "currentPlayerTurn": currentPlayerTurn,
            "winner": winner,
            "cells": cells.map({ $0.toAnyObject() })
        ]
    }
    
    func anyEmptyCells() -> Bool {
        let emptyCells = self.cells.filter { $0.value == XO.empty }
        return emptyCells.count > 0
    }
    
    func toggleCell(linkedToCellAt: Int) {
        let cell = cells[linkedToCellAt]
        print("toggleCell. cell.row=\(cell.row), cell.col=\(cell.col), currentPlayerTurn=\(currentPlayerTurn)")
        if currentPlayerTurn == playerOne {
            self.cells[linkedToCellAt].value = XO.x
            currentPlayerTurn = playerTwo
        } else {
            self.cells[linkedToCellAt].value = XO.o
            currentPlayerTurn = playerOne
        }
        tick()
    }
    
    func tick() {
        self.winner = detectWinner()
        if self.winner != "" {
            print("game over, \(self.winner) won")
            self.isComplete = true
            self.ref?.updateChildValues(self.toAnyObject() as! [AnyHashable : Any])
            return
        }
        if !anyEmptyCells() {
            print("game over, no empty cells")
            if self.winner == "" {
                self.winner = "tie"
            }
            self.isComplete = true
            self.ref?.updateChildValues(self.toAnyObject() as! [AnyHashable : Any])
            return
        }
        if currentPlayerTurn == "CPU" && !isComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.cpuMakeMove()
            })
        }
    }
    
    func cpuMakeMove() {
        if (anyEmptyCells() && currentPlayerTurn == "CPU") {
            print("cpu make move")
            let emptyCells = self.cells.filter { $0.value == XO.empty }
            let cellToChange = emptyCells.randomElement()!
            let index = self.cells.firstIndex(of: cellToChange)!
            self.cells[index].value = XO.o
            currentPlayerTurn = playerOne
            self.ref?.updateChildValues(self.toAnyObject() as! [AnyHashable : Any])
        }
        tick()
    }
    
    func detectWinner() -> String {
        // check for horizontal three in a row
        if cells[0...2].allSatisfy({ $0.value == XO.x }) {
            return playerOne
        }
        if cells[0...2].allSatisfy({ $0.value == XO.o }) {
            return playerTwo
        }
        if cells[3...5].allSatisfy({ $0.value == XO.x }) {
            return playerOne
        }
        if cells[3...5].allSatisfy({ $0.value == XO.o }) {
            return playerTwo
        }
        if cells[6...8].allSatisfy({ $0.value == XO.x }) {
            return playerOne
        }
        if cells[6...8].allSatisfy({ $0.value == XO.o }) {
            return playerTwo
        }
        // check for vertical three in a row
        if [cells[0], cells[3], cells[6]].allSatisfy({ $0.value == XO.x }) {
            return playerOne
        }
        if [cells[0], cells[3], cells[6]].allSatisfy({ $0.value == XO.o }) {
            return playerTwo
        }
        if [cells[1], cells[4], cells[7]].allSatisfy({ $0.value == XO.x }) {
            return playerOne
        }
        if [cells[1], cells[4], cells[7]].allSatisfy({ $0.value == XO.o }) {
            return playerTwo
        }
        if [cells[2], cells[5], cells[8]].allSatisfy({ $0.value == XO.x }) {
            return playerOne
        }
        if [cells[2], cells[5], cells[8]].allSatisfy({ $0.value == XO.o }) {
            return playerTwo
        }
        // check for diagonal three in a row
        let diagonalPermutations: [[Int]] = [
            [0, 4, 8],
            [2, 4, 6]
        ]
        for diagonal in diagonalPermutations {
            if diagonal.allSatisfy({ cells[$0].value == XO.x }) {
                return playerOne
            }
            if diagonal.allSatisfy({ cells[$0].value == XO.o }) {
                return playerTwo
            }
        }
        return ""
    }
}


