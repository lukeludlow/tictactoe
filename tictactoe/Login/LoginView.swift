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
    
    @State var showRegisterModal = false
    
    @EnvironmentObject var session: SessionStore
    
    func login() {
        loading = true
        error = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
                print("\(String(describing: error))")
                self.errorText = String(describing: error)
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
//                NavigationLink(destination: RegisterView(), tag: 1, selection: $navigationAction) {
//                    EmptyView()
//                }
                TextField("email address", text: $email)
                    .padding()
                SecureField("password", text: $password)
                    .padding()
                Button("login") {
                    login()
                }.padding()
//                Button(action: { self.navigationAction = 1 }) {
//                    Text("register")
//                }.padding()
//                Button("register") {
//                    self.navigationAction = 1
//                }.padding()
                Button("register") {
                    self.showRegisterModal.toggle()
                }
            }
            .sheet(isPresented: $showRegisterModal) {
                RegisterView(showModal: $showRegisterModal)
                    .environmentObject(self.session)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
