//
//  InviteView.swift
//  InviteView
//
//  Created by Wisse Hes on 24/08/2021.
//

import SwiftUI

struct InviteView: View {
    
    var invite: InviteItem
    @StateObject var viewModel = InviteViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("invite.sharedPet")
                    Text(invite.pet.name)
                        .font(.system(.body, design: .monospaced))
                }.padding()
                
                if let qrCode = viewModel.QRCode {
                    Image(uiImage: qrCode)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                
                Text("invite.scanQRCode")
                    .font(.footnote)
            }
        }
        .onAppear(perform: { viewModel.onAppear(invite: invite) })
        .navigationTitle("invite")
    }
}

struct InviteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InviteView(invite: InviteItem(
                id: 1,
                invitationCode: "code123",
                from: InviteFrom(name: "Wisse"),
                pet: Pet(name: "loulou", id: 1)
            ))
        }
    }
}
