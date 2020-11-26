//
//  tictactoeApp.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-25.
//

import SwiftUI

@main
struct tictactoeApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .environmentObject(DataStore())
        }
    }
}
