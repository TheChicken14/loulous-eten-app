//
//  PetView.swift
//  PetView
//
//  Created by Wisse Hes on 04/09/2021.
//

import SwiftUI

struct PetView: View {
    var pet: Pet
    
    @StateObject var viewModel = PetViewModel()
    
    var avatarEditButton: some View {
        Button {
            viewModel.showSheet(.imagePicker)
        } label: {
            ZStack {
                if viewModel.uploading {
                    ProgressView()
                } else {
                    Label("edit", systemImage: "pencil")
                        .labelStyle(.iconOnly)
                }
            }
            .font(Font.system(size: 25))
            .frame(width: 125, height: 125)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
        }.buttonStyle(.plain)
    }
    
    var body: some View {
        ZStack {
            if !viewModel.loading {
                Form {
                    
                    HStack {
                        Spacer()
                        PetAvatar(pet: viewModel.pet)
                            .overlay(
                                viewModel.editing ? avatarEditButton : nil
                            )
                        Spacer()
                    }
                    
                    EditItem(
                        label: "general.name",
                        systemImage: "circle.dashed.inset.fill",
                        editing: viewModel.editing,
                        text: $viewModel.name
                    )
                    
                    HStack {
                        Label("createPet.birthday", systemImage: "calendar")
                            .font(Font.body.bold())
                        
                        Spacer()
                        
                        DatePicker(
                            selection: $viewModel.birthdate,
                            displayedComponents: [.date]
                        ) {
                            Label("createPet.birthday", systemImage: "calendar")
                                .font(Font.body.bold())
                        }.disabled(!viewModel.editing).labelsHidden()
                        
                    }
                    
                    EditItem(
                        label: "createPet.morningFood",
                        systemImage: "leaf.fill",
                        editing: viewModel.editing,
                        text: $viewModel.morningFood
                    )
                    
                    EditItem(
                        label: "createPet.eveningFood",
                        systemImage: "leaf.fill",
                        editing: viewModel.editing,
                        text: $viewModel.dinnerFood
                    )
                    
                    Button {
                        viewModel.showSheet(.extraNotes)
                    } label: {
                        Label("createPet.extraNotes", systemImage: "text.bubble.fill")
                            .font(Font.body.bold())
                    }
                    
                    if viewModel.editing {
                        HStack {
                            Spacer()
                            
                            Button {
                                viewModel.save()
                            } label: {
                                switch viewModel.savingState {
                                case .normal:
                                    Label("general.save", systemImage: "checkmark")
                                case .loading:
                                    ProgressView()
                                case .success:
                                    Label("general.success", systemImage: "checkmark.circle").labelStyle(.iconOnly)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            else {
                ProgressView()
            }
        }.navigationTitle(pet.name).onAppear {
            viewModel.load(petID: pet.id)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.editing = !viewModel.editing
                } label: {
                    Label("edit", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $viewModel.sheetShown) {
            switch viewModel.whichSheet {
            case .extraNotes:
                ExtraNotesSheet(extraNotes: $viewModel.extraNotes, editing: viewModel.editing)
            case .imagePicker:
                ImagePicker(image: $viewModel.selectedImage)
            }
        }
    }
}


struct EditItem: View {
    let label: LocalizedStringKey
    let systemImage: String
    let editing: Bool
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            Label(label, systemImage: systemImage)
                .font(Font.body.bold())
            
            Spacer()
            
            TextField(label, text: $text)
                .multilineTextAlignment(.trailing)
                .foregroundColor(editing ? .primary : .secondary)
                .disabled(!editing)
        }
    }
}

struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PetView(pet: Pet(name: "Loulou", id: 1))
        }
    }
}
