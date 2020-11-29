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
}


