//
//  LoginScreen.swift
//  LoginScreen
//
//  Created by Wisse Hes on 21/08/2021.
//

import SwiftUI

struct LoginScreen: View {
    var loading: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if loading {
                    ProgressView()
                } else {
                    Link(destination: URL(string: "\(Config.API_URL)/auth/google")!) {
                        Text("login.withGoogle")
                            .foregroundColor(.white)
                            .frame(width: 280, height: 50)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                }
            }.navigationTitle("login.name")
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(loading: false)
    }
}
