//
//  AddFirstPetView.swift
//  AddFirstPetView
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI

struct AddFirstPetView: View {

    @State var nextScreenActive = false
    @State var petProfile = CreatePetProfileData(
        name: "",
        birthdate: Date(),
        morningFood: "",
        dinnerFood: "",
        extraNotes: ""
    )
    @Binding var sheetShown: Bool
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination:
                    FirstPetDoneView(
                        petProfile: petProfile,
                        sheetShown: $sheetShown
                    ),
                isActive: $nextScreenActive
            ) {
                EmptyView()
            }
            Form {
                Text("createPet.header")
                    .bold()
                
                HStack {
                    Label("general.name", systemImage: "circle.dashed.inset.fill")
                        .font(Font.body.bold())
                    Spacer()
                    TextField(
                        LocalizedStringKey("general.name"),
                        text: $petProfile.name
                    )
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    DatePicker( selection: $petProfile.birthdate, displayedComponents: [.date]) {
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
                        text: $petProfile.morningFood
                    )
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Label("createPet.eveningFood", systemImage: "leaf.fill")
                        .font(Font.body.bold())
                    Spacer()
                    TextField(
                        LocalizedStringKey("createPet.eveningFood"),
                        text: $petProfile.dinnerFood
                    )
                        .multilineTextAlignment(.trailing)
                }
                
                NavigationLink {
                    ZStack {
                        TextEditor(text: $petProfile.extraNotes)
                            .padding(.horizontal)
                        
                        if petProfile.extraNotes.isEmpty {
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
                    Button("welcome.done") {
                        nextScreenActive = true
                    }.disabled(petProfile.name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
                    Spacer()
                }
            }.navigationTitle("createPet").lineLimit(nil)
        }
    }
}

struct AddFirstPetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddFirstPetView(sheetShown: .constant(true))
        }
    }
}
