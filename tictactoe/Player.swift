//
//  Player.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import Foundation
import FirebaseDatabase

class Player: Identifiable {
    var ref: DatabaseReference?
    var uid: String
    var username: String
    var wins: Int
    var losses: Int
    
    init(uid: String, username: String, wins: Int, losses: Int) {
        ref = nil
        self.uid = uid
        self.username = username
        self.wins = wins
        self.losses = losses
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let uid = value["uid"] as? String,
            let username = value["username"] as? String,
            let wins = value["wins"] as? Int,
            let losses = value["losses"] as? Int
            else {
                return nil
            }
        self.ref = snapshot.ref
//        self.id = UUID(uuidString: id)!
        self.uid = uid
        self.username = username
        self.wins = wins
        self.losses = losses
    }
    
    func toAnyObject() -> Any {
        return [
            "uid": uid,
            "username": username,
            "wins": wins,
            "losses": losses
        ]
    }
}
