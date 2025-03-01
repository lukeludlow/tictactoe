//
//  Dashboard.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI
import ToastUI

struct Dashboard: View {
   
    @State private var navigationAction: Int? = 0
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    @State var showingAddGameAlert = false
    @State var selectedGame: Game?

    func incrementPlayerWins() {
        for player in self.database.players {
            if player.uid == self.session.session?.uid {
                player.wins += 1
                player.ref?.updateChildValues(["wins": player.wins])
            }
        }
    }
    
    func initNewGameAgainst(playerTwo: String) {
        let newGame = Game(playerOne: self.session.session!.displayName, playerTwo: playerTwo)
        let newGameRef = self.database.ref.child("games").child("\(newGame.uid)")
        newGame.ref = newGameRef
        self.database.addGame(game: newGame)
        self.selectedGame = newGame
    }
 
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                NavigationLink(
                    destination: LazyView { MultiPlayerGameView(game: selectedGame ?? Game())
                                            .environmentObject(self.session)
                                            .environmentObject(self.database)},
                    tag: 1,
                    selection: $navigationAction) {
                    EmptyView()
                }
                NavigationLink(
                    destination: LazyView { MultiPlayerGameView(game: selectedGame ?? Game())
                                            .environmentObject(self.session)
                                            .environmentObject(self.database)},
                    tag: 2,
                    selection: $navigationAction) {
                    EmptyView()
                }
                VStack(alignment: .leading) {
                    Text("player stats")
                        .font(.title)
                    VStack(alignment: .leading) {
                        ForEach(self.database.players) { player in
                            if player.uid == self.session.session?.uid {
                                Text("\(player.username)")
                                Text("wins: \(player.wins)")
                                Text("losses: \(player.losses)")
                            }
                        }
                    }
                    .frame(height: 100)
                    Text("open games")
                        .font(.title)
                    GeometryReader { geometry in
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(database.games) { game in
                                if !game.isComplete {
                                    GamePreviewRow(game: game)
                                        .onTapGesture {
                                            print("game preview row tapped")
                                            self.selectedGame = game
                                            self.navigationAction = 2
                                        }
                                        .frame(minWidth: geometry.size.width, maxWidth: .infinity)
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: 300)
                    }
                }.onAppear() {
                    self.database.observePlayers()
                    self.database.observeGames()
                }
                .padding()
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("+") {
                            print("add")
                            self.showingAddGameAlert = true
                        }
                        .actionSheet(isPresented: $showingAddGameAlert) {
                            ActionSheet(title: Text("title"), message: Text("message"), buttons: [
                                .default(Text("single player")) {
                                    print("start single player game")
                                    self.initNewGameAgainst(playerTwo: "CPU")
                                    self.navigationAction = 1
                                },
                                .default(Text("two player")) {
                                    print("start two player game")
                                    self.initNewGameAgainst(playerTwo: "")
                                    self.navigationAction = 2
                                },
                                .cancel()
                            ])
                        }
                        .font(.largeTitle)
                        .frame(width: 77, height: 77)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(38.5)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                        .padding()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) {_ in
                        if self.navigationAction == nil || self.navigationAction == 0 {
                            self.showingAddGameAlert = true
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("dashboard"))
            .navigationBarItems(trailing: Button("logout") {
                print("logout")
                let successfulSignout = self.session.signOut()
                if successfulSignout {
                    print("signed out successfully")
                } else {
                    print("failed to sign out")
                }
            })
        
        }
    }
}

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(SessionStore())
            .environmentObject(FirebaseDatabaseStore())
    }
}
