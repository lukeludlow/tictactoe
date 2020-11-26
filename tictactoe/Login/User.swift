//
//  User.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import Foundation

class User {
    var uid: String
    var email: String
    var displayName: String

    init(uid: String, displayName: String, email: String) {
        self.uid = uid;
        self.email = email;
        self.displayName = displayName;
    }
}
