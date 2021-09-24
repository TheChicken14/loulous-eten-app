//
//  QRCode.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import Foundation

struct QRCode: Codable {
    let petId: Int
    let pet: Pet
    let type: QRCodeType
    let id: Int?
    var createdAt: String?
    
    var createdAtDate: Date? {
        guard let date = createdAt else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: date)
    }
}
