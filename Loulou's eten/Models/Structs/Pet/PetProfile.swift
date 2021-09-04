//
//  PetProfile.swift
//  PetProfile
//
//  Created by Wisse Hes on 03/09/2021.
//

import Foundation

struct PetProfile: Codable {
    let id: Int
    let petId: Int
    
    let picturePath: String?
    let birthday: String?
    var birthdayDate: Date? {
        guard let date = birthday else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }
    let morningFood: String
    let dinnerFood: String
    let extraNotes: String
}

struct CreatePetProfileData: Codable {
    var name: String
    var birthdate: Date
    var morningFood: String
    var dinnerFood: String
    var extraNotes: String
}
