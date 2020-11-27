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
    
//    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User?
//    var session: User? { didSet {
//        print("didSet session user")
//        self.didChange.send(self)
//    }}
    var handle: AuthStateDidChangeListenerHandle?
    
    init(session: User? = nil) {
        print("init session store")
        self.session = session
    }
    
    func listen() {
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { (auth, firebaseUser) in
            if let user = firebaseUser {
                print("got user: \(user.email ?? "") \(user.uid)")
//                self.session = Auth.auth().currentUser
                self.session = User(uid: user.uid, displayName: user.displayName ?? "username", email: user.email ?? "email")
            } else {
                self.session = nil
            }
        }
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}
