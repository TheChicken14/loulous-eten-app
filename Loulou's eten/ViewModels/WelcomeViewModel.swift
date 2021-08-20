//
//  WelcomeViewModel.swift
//  WelcomeViewModel
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation
import Combine

class WelcomeViewModel: ObservableObject {
    @Published var name = ""
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    func saveName() {
        if name.trimmingCharacters(in: .whitespaces).count == 0 {
            return;
        }
        print(name)
        
        UserDefaults.standard.set(name, forKey: "name")
        self.shouldDismissView = true
    }
}
