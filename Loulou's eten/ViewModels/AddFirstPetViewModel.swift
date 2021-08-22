//
//  AddFirstPetViewModel.swift
//  AddFirstPetViewModel
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation

class AddFirstPetViewModel: ObservableObject {
    @Published var loading: Bool = true
    
    func addPet(name: String) {
        let parameters = CreatePetParams(name: name)
        
        API.request(
            "\(Config.API_URL)/pet/create",
            method: .post,
            parameters: parameters
        ).validate().response { response in
            switch response.result {
            case .success(_):
                self.loading = false
                print("done")
            case .failure(let error):
                print(error)
            }
        }
    }
}

