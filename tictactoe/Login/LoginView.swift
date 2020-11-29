//
//  LoginView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI

struct LoginView: View {
    
    @State private var navigationAction: Int? = 0
    
    @State var email: String = ""
    @State var password: String = ""
    @State var loading: Bool =  false
    @State var error: Bool = false
    @State var errorText: String = ""
    
    @State var success: Bool = false
    
    @State var showRegisterModal = false
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore

    func login() {
        loading = true
        error = false
        success = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                print("\(String(describing: error))")
                self.errorText = String(describing: error)
                self.error = true
            } else {
                self.email = ""
                self.password = ""
                self.success = true
            }
        }
    }
    
    var body: some View {
//        NavigationView {
            VStack {
                TextField("email address", text: $email)
                    .padding()
                SecureField("password", text: $password)
                    .padding()
                Button("login") {
                    login()
                }
                .padding()
                Button("register") {
                    self.showRegisterModal.toggle()
                }
            }
            .sheet(isPresented: $showRegisterModal) {
                RegisterView(showModal: $showRegisterModal)
                    .environmentObject(self.session)
                    .environmentObject(self.database)
            }
//        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
