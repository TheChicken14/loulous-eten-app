//
//  AddFirstPetViewModel.swift
//  AddFirstPetViewModel
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation
import Alamofire

class AddFirstPetViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var error: Bool = false
    
    func addPet(petProfile: CreatePetProfileData) {
        let parameters = petProfile
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(dateEncoding: .iso8601))
        
        API.request(
            "\(Config.API_URL)/pet/create",
            method: .post,
            parameters: parameters,
            encoder: encoder
        ).validate().response { response in
            switch response.result {
            case .success(_):
                self.loading = false
                print("done")
            case .failure(let error):
                self.error = true
                print(error)
            }
        }
    }
}

