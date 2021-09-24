//
//  ManageQRCodesViewModel.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import Foundation

final class ManageQRCodesViewModel: ObservableObject {
    
    @Published var loading: Bool = true
    @Published var QRCodes: [QRCode] = []
    
    @Published var sheetShown: Bool = false {
        didSet {
            loadCodes()
        }
    }
    
    init() {
        self.loadCodes()
    }
    
    func loadCodes() {
//        self.QRCodes = QRCodeManager.getQRCodes()
        QRCodeAPI.getQRCodes().validate().responseDecodable(of: [QRCode].self) { response in
            self.loading = false
            switch response.result {
            case .success(let codes):
                self.QRCodes = codes
            case .failure(let error):
                print(error)
            }
        }
    }
}
