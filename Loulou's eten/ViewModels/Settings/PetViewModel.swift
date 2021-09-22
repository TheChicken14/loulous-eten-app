//
//  PetViewModel.swift
//  PetViewModel
//
//  Created by Wisse Hes on 04/09/2021.
//

import Foundation
import Alamofire
import UIKit

enum PetViewSheet {
    case extraNotes
    case imagePicker
}

final class PetViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var savingState: ButtonState = .normal
    @Published var editing: Bool = false
    
    @Published var pet: Pet?
    
    @Published var name: String = ""
    
    @Published var birthdate: Date = Date()
    
    @Published var morningFood: String = ""
    @Published var dinnerFood: String = ""
    @Published var extraNotes: String = ""
    
    @Published var selectedImage: UIImage = UIImage(systemName: "photo")! {
        didSet {
            print("selectedImage set")
            upload()
        }
    }
    @Published var uploading: Bool = false
    
    @Published var sheetShown: Bool = false
    @Published var whichSheet: PetViewSheet = .extraNotes
    
    func load(petID: Int) {
        API.request("\(Config.API_URL)/pet/profile/\(petID)").validate().responseDecodable(of: Pet.self) { response in
            self.loading = false
            
            switch response.result {
            case .success(let petData):
                self.pet = petData
                self.name = petData.name
                if let birthdate = petData.profile?.birthdayDate {
                    self.birthdate = birthdate
                }
                if let morningFood = petData.profile?.morningFood {
                    self.morningFood = morningFood
                }
                if let dinnerFood = petData.profile?.dinnerFood {
                    self.dinnerFood = dinnerFood
                }
                if let extraNotes = petData.profile?.extraNotes {
                    self.extraNotes = extraNotes
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func save() {
        guard let pet = pet else {
            return
        }
        
        let params = CreatePetProfileData(
            name: name,
            birthdate: birthdate,
            morningFood: morningFood,
            dinnerFood: dinnerFood,
            extraNotes: extraNotes
        )
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(dateEncoding: .iso8601))
        
        API.request("\(Config.API_URL)/pet/profile/update/\(pet.id)", method: .post, parameters: params, encoder: encoder)
            .validate()
            .response { response in
                switch response.result {
                case .success(_):
                    self.savingState = .success
                case .failure(let err):
                    print(err)
                }
                
                self.doneSaving()
        }
    }
    
    func upload() {
        guard let imgData = selectedImage.jpegData(compressionQuality: 1), let pet = pet else {
            print("no imgdata/pet")
            return
        }
        
        API.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "picture", fileName: "picture.jpg", mimeType: "image/jpeg")
        }, to: "\(Config.API_URL)/pet/upload/photo/\(pet.id)")
            .uploadProgress { progress in
                print("Progress: \(progress)")
            }
            .response { _ in
                self.haptic()
                self.load(petID: pet.id)
                self.editing = false
            }
    }
    
    func doneSaving() {
        haptic()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.editing = false
            self.savingState = .normal
        }
    }
    
    func haptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func showSheet(_ sheet: PetViewSheet) {
        self.whichSheet = sheet
        self.sheetShown = true
    }
    func onDismiss() {
        if self.whichSheet == .imagePicker {
            self.upload()
        }
    }
}
