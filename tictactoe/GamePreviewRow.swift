//
//  GamePreviewRow.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI

struct GamePreviewRow: View {
    var game: Game
    
    var body: some View {
        HStack {
            Text(game.id)
        }
    }
}

struct GamePreviewRow_Previews: PreviewProvider {
    static var previews: some View {
        GamePreviewRow(game: Game(key: "1", playerOne: "", playerTwo: "", isComplete: false))
    }
}
