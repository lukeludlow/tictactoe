//
//  TicTacToeGame.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import Foundation
import FirebaseDatabase

class Game: Identifiable {
   
    let ref: DatabaseReference?
    let id: String
    var playerOne: String
    var playerTwo: String
    var isComplete: Bool
    
    init(key: String, playerOne: String, playerTwo: String, isComplete: Bool) {
        self.ref = nil
        self.id = key
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.isComplete = isComplete
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? String,
            let playerOne = value["playerOne"] as? String,
            let playerTwo = value["playerTwo"] as? String,
            let isComplete = value["isComplete"] as? Bool
            else {
                return nil
            }
        self.ref = snapshot.ref
        self.id = id
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.isComplete = isComplete
    }
}
