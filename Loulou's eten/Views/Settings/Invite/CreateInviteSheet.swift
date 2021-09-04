//
//  CreateInviteSheet.swift
//  CreateInviteSheet
//
//  Created by Wisse Hes on 25/08/2021.
//

import SwiftUI

struct CreateInviteSheet: View {
    
    @Binding var sheetShown: Bool
    
    @StateObject var viewModel = CreateInviteViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                if viewModel.loading {
                    ProgressView()
                } else {
                    
                    Text("createInvite.explanation")
                        .font(.subheadline)
                    
                    HStack {
                        Label("home.pet", systemImage: "leaf.fill")
                        Spacer()
                        Picker("home.pet", selection: $viewModel.selectedPetIndex) {
                            ForEach(0..<viewModel.pets.count, id: \.self) { index in
                                Text(viewModel.pets[index].name)
                                    .tag(index)
                            }
                        }.pickerStyle(.menu)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.createInvite()
                        } label: {
                            switch viewModel.savingState {
                            case .normal:
                                Label("general.done", systemImage: "checkmark")
                            case .loading:
                                ProgressView()
                            case .success:
                                Label("general.success", systemImage: "checkmark.circle")
                            }
                        }.disabled(viewModel.savingState == .loading || viewModel.savingState == .success)
                        
                        Spacer()
                    }
                }
            }
            .onAppear(perform: viewModel.loadPets)
            .navigationTitle("invite.createHeader")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        self.sheetShown = false
                    } label: {
                        Label("general.close", systemImage: "xmark.circle")
                    }
                }
            }
            .onReceive(viewModel.viewDismissalModePublisher) { output in
                if output {
                    self.sheetShown = false
                }
            }
        }
    }
}

struct CreateInviteSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateInviteSheet(sheetShown: .constant(false))
    }
}
