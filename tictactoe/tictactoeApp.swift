//
//  tictactoeApp.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-25.
//

import SwiftUI
import Firebase

@main
struct tictactoeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SessionStore())
                .environmentObject(FirebaseDatabaseStore())
        }
    }
}
