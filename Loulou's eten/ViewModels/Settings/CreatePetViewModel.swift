//
//  CreatePetViewModel.swift
//  CreatePetViewModel
//
//  Created by Wisse Hes on 28/08/2021.
//

import Foundation
import UIKit
import Combine

final class CreatePetViewModel: ObservableObject {
    @Published var buttonState: ButtonState = .normal
    @Published var error: Bool = false
    
    @Published var name: String = ""
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    func createPet() {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return;
        }
        
        buttonState = .loading
        
        let params = CreatePetParams(name: name)
        API.request("\(Config.API_URL)/pet/create", method: .post, parameters: params).validate().response { response in
            switch response.result {
            case .success(_):
                self.buttonState = .success
                self.haptic()
                self.error = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.shouldDismissView = true
                }
                
            case .failure(_):
                self.error = true
            }
        }
    }
    
    func haptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
