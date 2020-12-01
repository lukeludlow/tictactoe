//
//  GamePreviewRow.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI

struct GamePreviewRow: View {
    
    @ObservedObject var game: Game
    
    func getGameStatusString() -> String {
        if game.playerOne != "" && game.playerTwo == "" {
            return "waiting for another player to join"
        } else if game.playerOne != "" && game.playerTwo != "" {
            return "in progress"
        } else {
            return "status"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(game.playerOne) vs \(game.playerTwo == "" ? "_____" : game.playerTwo)")
                .font(.body)
                .lineLimit(1)
                .frame(width: 300, alignment: .leading)
            Text("(\(getGameStatusString()))")
                .font(.body)
                .fontWeight(.thin)
                .lineLimit(1)
                .frame(width: 300, alignment: .leading)
        }
        .frame(width: 300, height: 69)
    }
}

struct GamePreviewRow_Previews: PreviewProvider {
    static var previews: some View {
        GamePreviewRow(game: Game())
    }
}
