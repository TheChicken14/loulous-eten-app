//
//  ManagePets.swift
//  ManagePets
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI

struct ManagePets: View {
    
    @StateObject var viewModel = ManagePetsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.pets, id: \.id) { pet in
                NavigationLink {
                    PetView(pet: pet)
                } label: {
                    Text(pet.name)
                        .bold()
                }
            }.onDelete(perform: viewModel.delete)
            
        }.navigationTitle("settings.pets")
            .alert(isPresented: $viewModel.alertShown) {
                switch viewModel.whichAlert {
                case .connectionError:
                    return Alert(
                        title: Text("alert.noConnection.title"),
                        message: Text("alert.noConnection.message"),
                        dismissButton: .cancel(Text("general.ok"))
                    )
                case .areYouSure:
                    return Alert(
                        title: Text("alert.areYouSure.title"),
                        message: Text("alert.areYouSure.message"),
                        primaryButton: .default(Text("alert.areYouSure.yes"), action: {
                            viewModel.imSure()
                        }),
                        secondaryButton: .cancel(Text("general.cancel"))
                    )
                }
            }
    }
}

struct ManagePets_Previews: PreviewProvider {
    static var previews: some View {
        ManagePets()
    }
}
