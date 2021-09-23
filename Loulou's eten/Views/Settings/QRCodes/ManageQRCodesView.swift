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
                Text(String(qrcode.petID))
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
}

struct ManageQRCodesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManageQRCodesView()
        }
    }
}
