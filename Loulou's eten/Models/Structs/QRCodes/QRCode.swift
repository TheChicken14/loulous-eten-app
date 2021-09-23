//
//  QRCode.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import Foundation

struct QRCode: Codable/*, Identifiable*/ {
    let petID: Int
    let type: QRCodeType
    
    
    var id = UUID()
    var createdAt = Date()
}
