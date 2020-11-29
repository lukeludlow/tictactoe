//
//  RegisterView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI
import ToastUI

struct RegisterView: View {
    
//    @State private var navigationAction: Int? = 0
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    @State var email: String = ""
    @State var password: String = ""
    @State var displayName: String = ""
    @State var loading = false
    @State var error = false
    @State var success = false
    @State var errorText = ""
    
    @Environment(\.editMode) var registerMode
    
    @Binding var showModal: Bool

    func register() {
        self.loading = true
        self.error = false
        self.success = false
        session.signUp(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                print("\(String(describing: error))")
                self.error = true
                self.errorText = String(describing: error)
            } else {
                let changeRequest = result?.user.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                changeRequest?.commitChanges { changeError in
                    if changeError != nil {
                        print("\(String(describing: changeError))")
                    } else {
                        print("profile display name updated successfully")
                    }
                }
                let player = Player(uid: session.session?.uid ?? "", username: displayName, wins: 0, losses: 0)
                self.database.addPlayer(player: player)
                self.email = ""
                self.password = ""
                self.displayName = ""
                self.success = true
                self.showModal = false
            }
        }
    }

    var body: some View {
//        NavigationView {
            VStack {
                Button("cancel") {
                    self.showModal = false
                }
//                }
//                NavigationLink(destination: RegisterView(), tag: 1, selection: $action) {
//                    EmptyView()
//                }
                TextField("display name", text: $displayName)
                    .padding()
                TextField("email address", text: $email)
                    .padding()
                SecureField("password", text: $password)
                    .padding()
                Button("register") {
                    register()
                }
//                .toast(isPresented: $loading, onDismiss: {
//                    print("loading toast dismissed")
//                    success = true
//                }) {
//                } content: {
//                    ToastView("loading...")
//                        .toastViewStyle(IndefiniteProgressToastViewStyle())
//                }
                .toast(isPresented: $success, dismissAfter: 2.0) {
                    print("success toast dismissed")
                    self.showModal = false
                } content: {
                    ToastView("success")
                        .toastViewStyle(SuccessToastViewStyle())
                }
                .toast(isPresented: $error, dismissAfter: 2.0) {
                    print("error toast dismissed")
                } content: {
                    ToastView("error: \(errorText)")
                        .toastViewStyle(ErrorToastViewStyle())
                }
                .padding()
            }
//        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(showModal: .constant(true))
            .environmentObject(SessionStore())
    }
}
