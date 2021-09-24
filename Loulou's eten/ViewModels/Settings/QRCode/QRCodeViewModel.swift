//
//  QRCodeViewModel.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 24/09/2021.
//

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

final class QRCodeViewModel: ObservableObject {
    @Published var loading: Bool = true
    
    @Published var qrCode: QRCode?
    @Published var qrCodeImage: UIImage?
    
    func createQRCode() -> UIImage {
        guard let qrCode = qrCode else {
            return UIImage(systemName: "xmark.circle") ?? UIImage()
        }
        
        var url = ""
        let context = CIContext()
        
        switch qrCode.type {
        case .feeding:
            url = "loulouapp://feed/\(qrCode.pet.id)"
        }
        
        let data = Data(url.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKeyPath: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledQrImage = outputImage.transformed(by: transform)
            
            if let cgimg = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func load(_ id: Int) {
        QRCodeAPI.getQRCode(id).validate().responseDecodable(of: QRCode.self) { response in
            self.loading = false
            
            switch response.result {
            case .success(let qrCode):
                self.qrCode = qrCode
                self.qrCodeImage = self.createQRCode()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
