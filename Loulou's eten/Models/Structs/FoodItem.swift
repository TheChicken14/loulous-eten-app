//
//  FoodItem.swift
//  FoodItem
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation

struct FoodItem: Codable {
    let by: FoodItemUser
//    let pet: Pet
    let id: Int
    let type: String
    let date: String?
    
    var whenDate: Date? {
        guard let date = date else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }

    enum CodingKeys: String, CodingKey {
        case by
//        case pet = "for"
        case id, type, date
    }
}

struct FoodItemUser: Codable {
    let id: Int
    let name: String
}
