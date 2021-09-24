//
//  QRCodeView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 24/09/2021.
//

import SwiftUI

struct QRCodeView: View {
    var qrId: Int
    
    @StateObject var viewModel = QRCodeViewModel()
    
    var qrView: some View {
        List {
            HStack {
                Text("home.pet")
                    .bold()
                Spacer()
                if let pet = viewModel.qrCode?.pet {
                    Text(pet.name)
                        .foregroundColor(.secondary)
                }
            }
            
            qrImage
            
            if let image = viewModel.qrCodeImage {
                Button {
                    let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
                    
                    let keyWindow = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .map({$0 as? UIWindowScene})
                            .compactMap({$0})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first
                    
                    keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
                    
//                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                } label: {
                    Label("qrcode.share", systemImage: "square.and.arrow.up")
                        .font(Font.body.bold())
                }
            }
        }
    }
    
    var qrImage: some View {
        Group {
            if let qrImage = viewModel.qrCodeImage {
                VStack(alignment: .center) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 500, maxHeight: 500)
                        .padding()
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else {
                qrView
            }
        }.navigationTitle("qrcode")
            .onAppear(perform: { viewModel.load(qrId) })
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QRCodeView(qrId: 1)
        }
    }
}
