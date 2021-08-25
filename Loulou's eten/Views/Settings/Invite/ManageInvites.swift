//
//  ManageInvites.swift
//  ManageInvites
//
//  Created by Wisse Hes on 24/08/2021.
//

import SwiftUI

struct ManageInvites: View {
    
    @StateObject var viewModel = ManageInvitesViewModel()
    
    var body: some View {
        List {
            Text("invite.explanation")
                .font(.subheadline)
            
            if viewModel.loading {
                loading
            }
            
            ForEach(viewModel.invites, id: \.id) { invite in
                NavigationLink(destination: { InviteView(invite: invite) }) {
                    InviteItemView(invite: invite)
                }
            }.onDelete(perform: viewModel.delete)
        }.navigationTitle("settings.invites")
            .onAppear(perform: viewModel.load)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.sheetShown = true
                    } label: {
                        Label("invite.create", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.sheetShown) {
                CreateInviteSheet(sheetShown: $viewModel.sheetShown)
            }
    }
    
    var loading: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct ManageInvites_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManageInvites()
        }
    }
}
