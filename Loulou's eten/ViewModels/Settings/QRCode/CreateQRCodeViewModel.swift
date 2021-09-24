//
//  CreateQRCodeViewModel.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import Foundation
import Combine

final class CreateQRCodeViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var savingState: ButtonState = .normal
    
    @Published var pets: [Pet] = []
    @Published var selectedPetIndex: Int = 0 {
        didSet {
            self.selectedPet = pets[selectedPetIndex]
        }
    }
    @Published var selectedPet: Pet?
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()

    func load() {
        API.request("\(Config.API_URL)/user/info").validate().responseDecodable(of: UserInfo.self) { response in
            self.loading = false
            switch response.result {
            case .success(let userInfo):
                self.pets = userInfo.pets
                self.selectedPet = userInfo.pets.first
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createQRCode() {
        guard let selectedPet = selectedPet else {
            return
        }

        let qr = QRCode(petId: selectedPet.id, pet: selectedPet, type: .feeding, id: nil)
        
        self.savingState = .loading
        
        QRCodeAPI.addQRCode(qr).validate().response { _ in
            self.savingState = .success
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewDismissalModePublisher.send(true)
            }
        }
    }
}
