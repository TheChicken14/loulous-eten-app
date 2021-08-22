//
//  PetStatus.swift
//  PetStatus
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation

struct PetStatus: Codable {
    let morning: FoodItem?
    let evening: FoodItem?
}

struct PetStatusFoodItem: Codable {
    let id: Int
    let date: String
    let type: FeedingType
    let by: FoodItemUser
}
