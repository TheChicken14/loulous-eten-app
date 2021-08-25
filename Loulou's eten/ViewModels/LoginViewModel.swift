//
//  LoginViewModel.swift
//  LoginViewModel
//
//  Created by Wisse Hes on 24/08/2021.
//

import Foundation
import AuthenticationServices
import Combine

class LoginViewModel: ObservableObject {
    @Published var loading: Bool = false
    
    @Published var errorAlert: Bool = false
    
    var loggedinPublisher = PassthroughSubject<Bool, Never>()
    
    func handleLogin(auth: ASAuthorization) {
        switch auth.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            guard let identityToken = credential.identityToken else {
                return;
            }
            
            let identityTokenString = String(decoding: identityToken, as: UTF8.self)
            
            let params = SIWAParams(
                token: identityTokenString,
                appleID: credential.user,
                email: credential.email,
                givenName: credential.fullName?.givenName,
                familyName: credential.fullName?.familyName
            )
            
            API.request(
                "\(Config.API_URL)/auth/apple",
                method: .post,
                parameters: params
            ).validate().responseDecodable(of: SIWAResponse.self) { response in
                self.loading = false
                switch response.result {
                case .success(let tokenRes):
                    UserDefaults.standard.set(tokenRes.jwt, forKey: "token")
                    self.loggedinPublisher.send(true)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            break;
        }
        
    }
}
