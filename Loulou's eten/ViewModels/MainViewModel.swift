//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation
import Alamofire

class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    @Published var showLoginView: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var errorAlert: Bool = false
    
    init() {
        let token = UserDefaults.standard.string(forKey: "token")
        if token != nil {
            isLoggedIn = true
        } else {
            showLoginView = true
        }
    }
    
    func onOpenURL(url: URL) {
        let isDeepLink = url.scheme == "loulouapp"
        let isAuth = url.host == "authenticate"
        
        if isDeepLink && isAuth {
            var token = url.path
            token.remove(at: token.startIndex)
            
            self.testToken(token: token) { success in
                switch success {
                case true:
                    self.isLoading = false
                    self.showLoginView = false
                    UserDefaults.standard.set(token, forKey: "token")
                    
                case false:
                    self.errorAlert = true
                }
            }
        }
    }
    
    func testToken(token: String, completed: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "authorization": token
        ]
        
        AF.request("\(Config.API_URL)/auth/test", headers: headers).validate().response { response in
            print(response.result)
            switch response.result {
            case .success(_):
                completed(true)
            case .failure(_):
                completed(false)
            }
        }
    }
}
