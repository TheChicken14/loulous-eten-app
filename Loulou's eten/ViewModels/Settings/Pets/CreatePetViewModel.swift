//
//  CreatePetViewModel.swift
//  CreatePetViewModel
//
//  Created by Wisse Hes on 28/08/2021.
//

import Foundation
import UIKit
import Combine
import Alamofire

final class CreatePetViewModel: ObservableObject {
    @Published var buttonState: ButtonState = .normal
    @Published var error: Bool = false
    
    @Published var pet = CreatePetProfileData(
        name: "",
        birthdate: Date(),
        morningFood: "",
        dinnerFood: "",
        extraNotes: ""
    )
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    func createPet() {
        if pet.name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return;
        }
        
        buttonState = .loading
        
        let params = pet
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(dateEncoding: .iso8601))

        API.request("\(Config.API_URL)/pet/create", method: .post, parameters: params, encoder: encoder).validate().response { response in
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
