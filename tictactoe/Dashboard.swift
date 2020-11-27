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

    func incrementPlayerWins() {
        for (player) in self.database.players {
            if player.uid == self.session.session?.uid {
                player.wins += 1
                player.ref?.updateChildValues(["wins": player.wins])
            }
        }
    }

    var body: some View {
        VStack {
            ForEach(self.database.players) { player in
                if player.uid == self.session.session?.uid {
                    Text("\(player.username)")
                    Text("\(player.wins)")
                    Text("\(player.losses)")
                }
            }
            List {
                ForEach(database.games) { game in
                    GamePreviewRow(game: game)
                }
            }
            Button("win") {
                self.incrementPlayerWins()
//                ForEach(database.players) { player in
//                    if player.uid == session.session?.uid {
//                        player.ref.updateChildValues(["wins": player.wins])
//                    }
//                }
//                self.player?.wins += 1
//                database.players[playerUid]?.ref?.updateChildValues(["wins": self.player?.wins as Any])
//                database.updatePlayer(player: self.player!)
            }
            Button("lose") {
//                self.player?.losses += 1
//                database.updatePlayer(player: self.player!)
            }
        }.onAppear(perform: self.database.getPlayers)
        Button("logout") {
            let success = self.session.signOut()
            if success {
                print("signed out successfully")
            } else {
                print("failed to sign out. please try again.")
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(SessionStore())
            .environmentObject(FirebaseDatabaseStore())
    }
}
