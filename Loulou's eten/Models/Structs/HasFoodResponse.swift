//
//  HasFoodResponse.swift
//  HasFoodResponse
//
//  Created by Wisse Hes on 14/08/2021.
//

import Foundation

struct HasFoodResponse: Codable {
    let food: Bool
    let date: String?
    let type: FeedingType?
    let by: String?
    
    var whenDate: Date? {
        guard let date = date else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }
}

enum FeedingType: String, Codable {
    case evening = "evening"
    case morning = "morning"
}
