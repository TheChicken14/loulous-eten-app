//
//  QRCodeManager.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import Foundation

struct QRCodeManager {
    // UserDefaults key for QR Codes
    static let UDKey = "qrcodes"
    
    static func getQRCodes() -> [QRCode] {
        // Get saved data
        if let data = UserDefaults.standard.data(forKey: self.UDKey) {
            // Decode the save data (if existent)
            if let decoded = try? JSONDecoder().decode([QRCode].self, from: data) {
                print(decoded)
                // Return decoded JSON
                return decoded
            } else {
                // If it failed to decode: return an empty array
                return []
            }
        } else {
            // If there's no data: return an empty array
            return []
        }
    }
    
    // Add a QR code to the array of QR codes
    static func addQRCode(_ code: QRCode) {
        // Get current codes
        var codes = self.getQRCodes()
        // Add new code
        codes.append(code)
        // Save codes
        self.saveQRCodes(codes)
    }
    
    static func deleteQRCode(_ id: UUID) {
        // delete
    }
    
    private static func saveQRCodes(_ codes: [QRCode]) {
        if let encoded = try? JSONEncoder().encode(codes) {
//            print(String(encoded))
            print(String(data: encoded, encoding: .utf8) ?? "No Data")
            
            UserDefaults.standard.set(encoded, forKey: "qrcodes")
        }
    }
}
