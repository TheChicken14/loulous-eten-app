//
//  InviteItemView.swift
//  InviteItemView
//
//  Created by Wisse Hes on 24/08/2021.
//

import SwiftUI

struct InviteItemView: View {
    let invite: InviteItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("invite.for \(invite.pet.name)")
                .font(.headline)
            
            Spacer(minLength: 10)
            
            HStack {
                Text("invite.code")
                Text(invite.invitationCode)
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
}

struct InviteItemView_Previews: PreviewProvider {
    static var previews: some View {
        InviteItemView(
            invite: InviteItem(
                id: 1,
                invitationCode: "code123",
                from: InviteFrom(name: "Wisse"),
                pet: Pet(name: "loulou", id: 1)
            )
        ).frame(height: 50)
    }
}
