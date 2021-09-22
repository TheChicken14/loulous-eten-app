//
//  Pet.swift
//  Pet
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation

struct Pet: Codable {
    let name: String
    let id: Int
    
    var profile: PetProfile?
    var owners: [PetOwner]?
}
