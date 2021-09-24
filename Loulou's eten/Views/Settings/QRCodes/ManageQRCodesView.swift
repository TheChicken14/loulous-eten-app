//
//  ManageQRCodesView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 23/09/2021.
//

import SwiftUI

struct ManageQRCodesView: View {
    
    @StateObject var viewModel = ManageQRCodesViewModel()
    
    var body: some View {
        List {
            explanation
            
            ForEach(viewModel.QRCodes, id: \.id) { qrcode in
                NavigationLink {
                    QRCodeView(qrId: qrcode.id!)
                } label: {
                    listItem(qrcode)
                }
            }
        }.navigationTitle("qrcodes")
            .sheet(isPresented: $viewModel.sheetShown) {
                CreateQRCodeView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.sheetShown = true
                    } label: {
                        Label("qrcode.create", systemImage: "plus")
                    }
                }
            }
    }
    
    var explanation: some View {
        Text("qrcodes.explanation")
            .fixedSize(horizontal: false, vertical: true)
            .font(.subheadline)
            .padding(.vertical)
    }
    
    func listItem(_ qrcode: QRCode) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(qrcode.pet.name)'s QR code")
                .bold()
//                .padding(.vertical, 5)
            
            if let date = qrcode.createdAtDate {
                Text("Aangemaakt op \(date, style: .date)")
                    .font(.footnote)
            }
        }
    }
}

struct ManageQRCodesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManageQRCodesView()
        }
    }
}
