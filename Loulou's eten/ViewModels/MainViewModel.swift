//
//  MainViewModel.swift
//  MainViewModel
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation
import Alamofire
import Combine

class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false {
        didSet {
            if isLoggedIn {
                showLoginView = false
                reloadPublisher.send(true)
            }
        }
    }
    
    @Published var showLoginView: Bool = false

    var reloadPublisher = PassthroughSubject<Bool, Never>()

    init() {
        
        #if targetEnvironment(simulator)
        UserDefaults.standard.set(Config.SIMULATOR_KEY, forKey: "token")
        #endif
        
        let token = UserDefaults.standard.string(forKey: "token")
        if token != nil {
            isLoggedIn = true
        } else {
            showLoginView = true
        }
    }
}
