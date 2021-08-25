//
//  InviteViewModel.swift
//  InviteViewModel
//
//  Created by Wisse Hes on 24/08/2021.
//

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

class InviteViewModel: ObservableObject {
    @Published var QRCode: UIImage?
    
    let context = CIContext()
    
    func onAppear(invite: InviteItem) {
        let url = "loulouapp://invite/\(invite.invitationCode)"
        QRCode = createQRCode(from: url)
    }
    
    func createQRCode(from text: String) -> UIImage {
        let data = Data(text.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
