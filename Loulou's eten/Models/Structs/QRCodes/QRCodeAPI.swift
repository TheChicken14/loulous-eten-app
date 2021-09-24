//
//  QRCodeAPI.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 24/09/2021.
//

import Foundation
import Alamofire

struct QRCodeAPI {
    static func getQRCodes() -> DataRequest {
        return API.request("\(Config.API_URL)/qrcodes/all")
    }
    
    static func addQRCode(_ qrCode: QRCode) -> DataRequest {
        let params: Parameters = [
            "petID": qrCode.pet.id,
            "type": qrCode.type
        ]
        
        return API.request("\(Config.API_URL)/qrcodes/create", method: .post, parameters: params)
    }
    
    static func getQRCode(_ id: Int) -> DataRequest {
        return API.request("\(Config.API_URL)/qrcodes/get/\(id)")
    }
}
