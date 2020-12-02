//
//  FirebaseDatabase.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseDatabase

class FirebaseDatabaseStore: ObservableObject {
    
    @Published var games: [Game] = []
    @Published var players: [Player] = []

    var ref: DatabaseReference = Database.database().reference()
    
    func observeGames() {
        let postRef = ref.child("games")
        postRef.observe(DataEventType.value) { (snapshot) in
            self.games = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let game = Game(snapshot: snapshot) {
                    self.games.append(game)
                }
            }
        }
    }
    
    func addGame(game: Game) {
        print("addGame to database")
        let postRef = ref.child("games").child(game.uid)
        postRef.setValue(game.toAnyObject())
    }
    
    func observePlayers() {
        let postRef = ref.child("players")
        postRef.observe(DataEventType.value) { (snapshot) in
            self.players = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let player = Player(snapshot: snapshot) {
                    self.players.append(player)
                }
            }
        }
    }
    
    func addPlayer(player: Player) {
        print("adding player \(player.username) to database")
        let postRef = ref.child("players").child(player.uid)
        postRef.setValue(player.toAnyObject())
    }
    
    func updatePlayer(player: Player) {
        print("updating player \(player.username)")
        let update = ["username": player.username, "wins": player.wins, "losses": player.losses] as [String : Any]
        let childUpdate = ["/players/\(player.uid)": update]
        ref.updateChildValues(childUpdate)
    }
   
}
