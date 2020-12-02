//
//  MultiplayerGameView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-28.
//

import SwiftUI
import FirebaseDatabase

struct MultiPlayerGameView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    @ObservedObject var game: Game
    @State var observedGameId: String = ""

    init(game: Game) {
        self.game = game
    }

    func observeGame() {
        print("observeGame \(self.observedGameId)")
        let postRef = self.database.ref.child("games").child("\(self.observedGameId)")
        postRef.observe(DataEventType.value) { (snapshot) in
            if let observedGame = Game(snapshot: snapshot) {
                self.game.copyFrom(otherGame: observedGame)
                print("updated observed game state")
            }
        }
    }
    
    func createButton(linkedToCellAt: Int) -> some View {
        return Button(action: {
            game.toggleCell(linkedToCellAt: linkedToCellAt)
            game.ref?.updateChildValues(game.toAnyObject() as! [AnyHashable : Any])
        }) {
            Text("\(game.cells[linkedToCellAt].value.rawValue)")
                .font(.largeTitle)
                .frame(width: 100, height: 100)
        }
        .frame(width: 100, height: 100)
        .border(Color.black, width: 1)
    }
   
    var body: some View {
        VStack {
            Text("\(self.game.playerOne) vs \(self.game.playerTwo)")
                .padding(.bottom, 20)
            Text("\(game.currentPlayerTurn)'s turn")
                .padding(.bottom, 10)
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    createButton(linkedToCellAt: 0)
                    createButton(linkedToCellAt: 1)
                    createButton(linkedToCellAt: 2)
                }
                .frame(width: 300, height: 100)
                HStack(alignment: .center, spacing: 0) {
                    createButton(linkedToCellAt: 3)
                    createButton(linkedToCellAt: 4)
                    createButton(linkedToCellAt: 5)
                }
                .frame(width: 300, height: 100)
                HStack(alignment: .center, spacing: 0) {
                    createButton(linkedToCellAt: 6)
                    createButton(linkedToCellAt: 7)
                    createButton(linkedToCellAt: 8)
                }
                .frame(width: 300, height: 100)
            }
        }.onAppear() {
            let currentUserName = self.session.session?.displayName ?? "unknown"
            if self.game.playerOne != "" || self.game.playerTwo != "" {
                let playerWhoJoined = currentUserName == self.game.playerOne ? "one" : "two"
                print("player \(playerWhoJoined) joined the game")
                self.observedGameId = game.uid
            }
            if self.game.playerOne == "" && self.game.playerTwo == "" {
                print("creating new game")
                self.game.playerOne = self.session.session?.displayName ?? "player one"
                self.game.playerTwo = ""
                self.observedGameId = self.game.uid
                let gameRef = self.database.ref.child("games").child("\(self.observedGameId)")
                self.game.ref = gameRef
                self.database.addGame(game: self.game)
            }
            else if self.game.playerOne != currentUserName && self.game.playerTwo == "" {
                print("adding player two to the game")
                self.game.playerTwo = self.session.session?.displayName ?? "player two"
                self.game.ref?.updateChildValues(["playerTwo": game.playerTwo])
                self.observedGameId = game.uid
            }
            self.observeGame()
        }
    }
}


struct MultiplayerGameView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPlayerGameView(game: Game())
            .environmentObject(SessionStore())
            .environmentObject(FirebaseDatabaseStore())
    }
}
