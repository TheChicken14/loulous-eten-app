//
//  LoginScreen.swift
//  LoginScreen
//
//  Created by Wisse Hes on 21/08/2021.
//

import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
    @StateObject var viewModel = LoginViewModel()
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("login.welcomeText")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                if viewModel.loading {
                    ProgressView()
                }
                
                SignInWithAppleButton(.signIn) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                    case .success(let auth):
                        viewModel.loading = true
                        viewModel.handleLogin(auth: auth)
                    case .failure(let error):
                        print(error)
                    }
                }.frame(width: 300, height: 50).padding()
                
                Spacer()
            }.navigationTitle("welcome.title").onReceive(viewModel.loggedinPublisher) { loggedIn in
                self.isLoggedIn = loggedIn
            }.alert(isPresented: $viewModel.errorAlert) {
                Alert(
                    title: Text("alert.somethingWrong.title"),
                    message: Text("alert.somethingWrong.message"),
                    dismissButton: .cancel(Text("general.ok"))
                )
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(isLoggedIn: .constant(false))
    }
}
