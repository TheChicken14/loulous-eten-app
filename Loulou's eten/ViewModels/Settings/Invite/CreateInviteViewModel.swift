//
//  CreateInviteViewModel.swift
//  CreateInviteViewModel
//
//  Created by Wisse Hes on 01/09/2021.
//

import Foundation
import Combine

final class CreateInviteViewModel: ObservableObject {
    @Published var savingState: ButtonState = .normal
    @Published var loading: Bool = true
    
    @Published var pets: [Pet] = []
    @Published var selectedPet: Pet?
    @Published var selectedPetIndex: Int = 0 {
        didSet {
            self.selectedPet = pets[selectedPetIndex]
        }
    }
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    func loadPets() {
        API.request("\(Config.API_URL)/user/info").validate().responseDecodable(of: UserInfo.self){ response in
            switch response.result {
            case .success(let user):
                self.pets = user.pets
                self.selectedPet = user.pets[0]
                self.loading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createInvite() {
        guard let pet = selectedPet else {
            return
        }
        
        savingState = .loading
        API.request("\(Config.API_URL)/invite/create/\(pet.id)", method: .post).validate().response { response in
            self.savingState = .success
            self.shouldDismissView = true
        }
    }
}
