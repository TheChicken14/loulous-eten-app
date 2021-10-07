//
//  PetFeedingDay.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 28/09/2021.
//

import Foundation

struct PetFeedingDay: Identifiable {
//    let day: Date
    let day: String
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: day)
    }
    var feedingItems: [PetFeedingItem]
    
    var id = UUID()
}
