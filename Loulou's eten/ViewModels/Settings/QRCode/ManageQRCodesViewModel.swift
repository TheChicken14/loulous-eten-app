//
//  ManageQRCodesViewModel.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import Foundation

final class ManageQRCodesViewModel: ObservableObject {
    
    @Published var QRCodes: [QRCode] = []
    
    @Published var sheetShown: Bool = false {
        didSet {
            loadCodes()
        }
    }
    
    // UserDefaults key for QR Codes
    let UDKey = "qrcodes"
    
    init() {
        self.loadCodes()
    }
    
    func loadCodes() {
        self.QRCodes = QRCodeManager.getQRCodes()
    }
}
