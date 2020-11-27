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
    
    var body: some View {
        Button("logout") {
            if session.signOut() {
                print("signed out. going back to login screen.")
            } else {
                print("unable to sign out. please try again.")
            }
        }
        Text("wins:")
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(SessionStore())
    }
}
