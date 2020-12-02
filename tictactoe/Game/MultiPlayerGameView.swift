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
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var game: Game
    @State var observedGameId: String = ""
    @State var currentUserName = ""
    
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .gameOver

    init(game: Game) {
        self.game = game
    }
    
    func dismiss() {
        print("dismiss MultiPlayerGameView")
        self.presentationMode.wrappedValue.dismiss()
    }

    func observeGame() {
        print("observeGame \(self.observedGameId)")
        let postRef = self.database.ref.child("games").child("\(self.observedGameId)")
        postRef.observe(DataEventType.value) { (snapshot) in
            if let observedGame = Game(snapshot: snapshot) {
                self.game.copyFrom(otherGame: observedGame)
                if self.game.isComplete {
                    if self.game.winner == "tie" {
                        self.activeAlert = .tiedGame
                    } else {
                        self.activeAlert = .gameOver
                    }
                    self.showAlert = true
                }
                print("updated observed game state")
            }
        }
    }
    
    func onClickCell(linkedToCellAt: Int) {
        if game.currentPlayerTurn != self.currentUserName {
            self.activeAlert = .notTurn
            self.showAlert = true
        } else if game.cells[linkedToCellAt].value != XO.empty {
            self.activeAlert = .invalidMove
            self.showAlert = true
        } else if game.isComplete {
            if self.game.winner == "tie" {
                self.activeAlert = .tiedGame
            } else {
                self.activeAlert = .gameOver
            }
        } else {
            game.toggleCell(linkedToCellAt: linkedToCellAt)
            game.ref?.updateChildValues(game.toAnyObject() as! [AnyHashable : Any])
        }
    }
    
    func incrementPlayerWins() {
        print("increment player wins")
        for player in self.database.players {
            if player.uid == self.session.session?.uid {
                player.wins += 1
                player.ref?.updateChildValues(["wins": player.wins])
            }
        }
    }
    
    func decrementPlayerWins() {
        print("decrement player wins")
        for player in self.database.players {
            if player.uid == self.session.session?.uid {
                player.losses += 1
                player.ref?.updateChildValues(["losses": player.losses])
            }
        }
    }
    
    func forfeitGame() {
        if self.currentUserName == game.playerOne {
            game.winner = game.playerTwo == "" ? "nobody" : game.playerTwo
        } else if self.currentUserName == game.playerTwo {
            game.winner = game.playerOne
        }
        game.isComplete = true
        game.ref?.updateChildValues(game.toAnyObject() as! [AnyHashable : Any])
    }
    
    func createButton(linkedToCellAt: Int) -> some View {
        return Button(action: {
            onClickCell(linkedToCellAt: linkedToCellAt)
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
            let currentUserName = self.session.session!.displayName
            self.currentUserName = currentUserName
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
                if self.game.currentPlayerTurn == "" {
                    self.game.currentPlayerTurn = self.game.playerTwo
                }
                self.game.ref?.updateChildValues(["playerTwo": game.playerTwo, "currentPlayerTurn": game.currentPlayerTurn])
                self.observedGameId = game.uid
            }
            self.observeGame()
        }
        .alert(isPresented: $showAlert) {
            switch activeAlert {
                case .gameOver:
                    return Alert(
                        title: Text("game over"),
                        message: Text("\(game.winner) wins!"),
                        dismissButton: .default(Text("ok"), action: {
                            if game.winner == self.currentUserName {
                                incrementPlayerWins()
                            } else {
                                decrementPlayerWins()
                            }
                            dismiss()
                    }))
                case .notTurn:
                    return Alert(
                        title: Text("it's not your turn yet"),
                        dismissButton: .default(Text("ok"), action: {
                    }))
                case .invalidMove:
                    return Alert(
                        title: Text("invalid move"),
                        dismissButton: .default(Text("ok"), action: {
                    }))
            case .forfeitGame:
                return Alert(
                    title: Text("are you sure? if you leave, you lose this game."),
                    primaryButton: .default(Text("ok"), action: {
                        print("chose to forfeit game")
                        forfeitGame()
                        dismiss()
                    }),
                    secondaryButton: .cancel(Text("cancel"), action: {
                        print("cancel forfeit game")
                }))
            case .tiedGame:
                return Alert(
                    title: Text("game over"),
                    message: Text("it's a tie! your win/loss ratio will not be affected."),
                    dismissButton: .default(Text("ok"), action: {
                        dismiss()
                }))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            print("clicked back button")
            if self.game.playerTwo != "" {
                self.activeAlert = .forfeitGame
                self.showAlert = true
            } else {
                dismiss()
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("back to dashboard")
            }
        })
    }
}


struct MultiplayerGameView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPlayerGameView(game: Game())
            .environmentObject(SessionStore())
            .environmentObject(FirebaseDatabaseStore())
    }
}
