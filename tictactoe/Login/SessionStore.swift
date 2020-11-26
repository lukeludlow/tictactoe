//
//  SessionStore.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class SessionStore : ObservableObject {
    var didChange = PassthroughSubject<SessionStore, Never>()
    var session: User? { didSet { self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, firebaseUser) in
            if let user = firebaseUser {
                print("got user: \(user)")
//                self.session = Auth.auth().currentUser
                self.session = User(uid: user.uid, displayName: user.displayName!, email: user.email!)
            } else {
                self.session = nil
            }
        }
    }
}
