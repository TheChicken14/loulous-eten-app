//
//  CreatePetView.swift
//  CreatePetView
//
//  Created by Wisse Hes on 28/08/2021.
//

import SwiftUI

struct CreatePetView: View {
    
    @StateObject var viewModel = CreatePetViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Label("general.name", systemImage: "circle.dashed.inset.fill")
                        .font(Font.body.bold())
                    
                    Spacer()
                    
                    TextField(LocalizedStringKey("general.name"), text: $viewModel.pet.name)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    DatePicker( selection: $viewModel.pet.birthdate, displayedComponents: [.date]) {
                        Label("createPet.birthday", systemImage: "calendar")
                            .font(Font.body.bold())
                    }
                }
                
                HStack {
                    Label("createPet.morningFood", systemImage: "leaf.fill")
                        .font(Font.body.bold())
                    Spacer()
                    TextField(
                        LocalizedStringKey("createPet.morningFood"),
                        text: $viewModel.pet.morningFood
                    )
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Label("createPet.eveningFood", systemImage: "leaf.fill")
                        .font(Font.body.bold())
                    Spacer()
                    TextField(
                        LocalizedStringKey("createPet.eveningFood"),
                        text: $viewModel.pet.dinnerFood
                    )
                        .multilineTextAlignment(.trailing)
                }
                
                NavigationLink {
                    ZStack {
                        TextEditor(text: $viewModel.pet.extraNotes)
                            .padding(.horizontal)
                        
                        if  viewModel.pet.extraNotes.isEmpty {
                            VStack(alignment: .leading) {
                            Text("createPet.extraNotes")
                                .font(.custom("Helvetica", size: 24))
                                .opacity(0.25)
                                .multilineTextAlignment(.leading)
                            }
                        }
                    }
                    .navigationTitle("createPet.extraNotes")
                } label: {
                    Label("createPet.extraNotes", systemImage: "text.bubble.fill")
                        .font(Font.body.bold())
                }
                
                HStack {
                    Spacer()
                    Button {
                        viewModel.createPet()
                    } label: {
                        switch viewModel.buttonState {
                        case .normal:
                            Label("general.done", systemImage: "checkmark.circle")
                        
                        case .loading:
                            ProgressView()
                        
                        case .success:
                            Label("general.success", systemImage: "checkmark")
                                .labelStyle(.iconOnly)
                        }
                        
                    }.disabled(viewModel.buttonState == .loading || viewModel.buttonState == .success)
                    
                    Spacer()
                }
            }.navigationTitle("addPet.name")
                .onReceive(viewModel.viewDismissalModePublisher) { output in
                    if output == true {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Label("general.close", systemImage: "xmark.circle")
                        }
                    }
                }
        }
    }
}

struct CreatePetView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePetView()
    }
}
