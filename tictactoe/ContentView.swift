//
//  ContentView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                Dashboard()
                    .environmentObject(session)
                    .environmentObject(database)
            } else {
                let _ = print("content view session user: \(session.session)")
                LoginView()
                    .environmentObject(self.session)
                    .environmentObject(self.database)
            }
        }.onAppear(perform: getUser)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
            .environmentObject(FirebaseDatabaseStore())
    }
}
