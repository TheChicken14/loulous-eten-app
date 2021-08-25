//
//  UserInfo.swift
//  UserInfo
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation

struct UserInfo: Codable {
    let id: Int
    let name: String
    let email: String
//    let googleId: String
    let appleId: String
    
    let foodItems: [FoodItem]
    let pets: [Pet]
}
