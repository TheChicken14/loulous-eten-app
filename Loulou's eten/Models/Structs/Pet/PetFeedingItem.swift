//
//  PetFeedingItem.swift
//  PetFeedingItem
//
//  Created by Wisse Hes on 23/08/2021.
//

import Foundation

struct PetFeedingItem: Codable {
    let id: Int
    let byId: Int
    let by: PetHistoryUser
    let forId: Int
    let date: String
    let type: FeedingType
    
    var whenDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }
}

struct PetHistoryUser: Codable {
    let name: String
}
