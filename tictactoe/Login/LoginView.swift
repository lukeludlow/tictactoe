//
//  LoginView.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-26.
//

import SwiftUI
import ToastUI

struct LoginView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var database: FirebaseDatabaseStore
    
    @State private var navigationAction: Int? = 0
    @State var email: String = ""
    @State var password: String = ""
    @State var loading: Bool =  false
    @State var error: Bool = false
    @State var errorText: String = ""
    @State var success: Bool = false
    

    func login() {
        loading = true
        error = false
        success = false
        session.signIn(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                print("\(String(describing: error))")
                self.errorText = error?.localizedDescription ?? "error"
                self.error = true
            } else {
                self.email = ""
                self.password = ""
                self.success = true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: LazyView { RegisterView()
                                                        .environmentObject(session)
                                                        .environmentObject(database) },
                               tag: 1,
                               selection: $navigationAction) {
                    EmptyView()
                }
                
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
                        print("clicked register")
                        self.navigationAction = 1
                    }
                }
//                .toast(isPresented: $error, dismissAfter: 2.0) {
//                    print("error toast dismissed")
//                } content: {
//                    ToastView("error: \(errorText)")
//                        .toastViewStyle(ErrorToastViewStyle())
//                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
