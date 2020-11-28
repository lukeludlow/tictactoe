//
//  Dashboard.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI
import ToastUI

struct Dashboard: View {
   
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    @State var showingAddGameAlert = false
    
    @State private var navigationAction: Int? = 0

    func incrementPlayerWins() {
        for player in self.database.players {
            if player.uid == self.session.session?.uid {
                player.wins += 1
                player.ref?.updateChildValues(["wins": player.wins])
            }
        }
    }
    
    func createNewGameModel() -> GameViewViewModel {
        return GameViewViewModel(
            playerOne: "\(self.session.session?.displayName ?? "username")",
            playerTwo: "CPU",
            session: self.session,
            database: self.database
        )
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: GameView(viewModel: self.createNewGameModel()),
//                    destination: GameView(viewModel: GameViewViewModel(
//                                                playerOne: "\(self.session.session?.displayName ?? "username")",
//                                                playerTwo: "CPU",
//                                                session: self.session,
//                                                database: self.database)),
                    tag: 1,
                    selection: $navigationAction) {
                    EmptyView()
                }
                VStack {
                    Text("player stats")
                        .font(.title)
                    ScrollView(.vertical, showsIndicators: false) {
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
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(database.games) { game in
                            GamePreviewRow(game: game)
                        }
                    }
                    .frame(height: 300)
                    Button("win") {
                        self.incrementPlayerWins()
                    }
                    Button("lose") {
                        print("lose")
                    }
                }.onAppear(perform: self.database.getPlayers)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button("+") {
                            print("add")
                            self.showingAddGameAlert.toggle()
                        }
                        .actionSheet(isPresented: $showingAddGameAlert) {
                            ActionSheet(title: Text("title"), message: Text("message"), buttons: [
                                .default(Text("single player")) {
                                    print("start single player game")
                                    self.navigationAction = 1
                                },
                                .default(Text("two player")) {
                                    print("start two player game")
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
                }

            }
        }
        Button("logout") {
            print("logout")
//            let success = self.session.signOut()
//            if success {
//                print("signed out successfully")
//            } else {
//                print("failed to sign out. please try again.")
//            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Dashboard()
                .environmentObject(SessionStore())
                .environmentObject(FirebaseDatabaseStore())
        }
    }
}
