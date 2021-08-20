//
//  HistoryResponse.swift
//  HistoryResponse
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation

struct HistoryResponse: Codable {
    let history: [HistoryItem]
}

struct HistoryItem: Codable {
    let date: String
    let by: String
    let type: FeedingType
    let _id: String
    
    var whenDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }
}
