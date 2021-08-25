//
//  CreateInviteSheet.swift
//  CreateInviteSheet
//
//  Created by Wisse Hes on 25/08/2021.
//

import SwiftUI

struct CreateInviteSheet: View {
    
    @Binding var sheetShown: Bool
    
    @State var savingState: ButtonState = .normal
    @State var loading: Bool = true
    @State var selectedPetIndex: Int = 0 {
        didSet {
            self.selectedPet = self.pets[selectedPetIndex]
        }
    }
    @State var selectedPet: Pet?
    @State var pets: [Pet] = []
    
    var body: some View {
        NavigationView {
            Form {
                if loading {
                    ProgressView()
                } else {
                    HStack {
                        Label("home.pet", systemImage: "leaf.fill")
                        Spacer()
                        Picker("home.pet", selection: $selectedPet) {
                            ForEach(0..<pets.count, id: \.self) { index in
                                Text(pets[index].name).tag(index)
                            }
                        }.pickerStyle(.menu)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            createInvite()
                        } label: {
                            switch savingState {
                            case .normal:
                                Label("general.done", systemImage: "checkmark")
                            case .loading:
                                ProgressView()
                            case .success:
                                Label("general.success", systemImage: "checkmark.circle")
                            }
                        }.disabled(savingState == .loading || savingState == .success)
                        
                        Spacer()
                    }
                }
            }
            .onAppear(perform: loadPets)
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
        }
    }
    
    func loadPets() {
        API.request("\(Config.API_URL)/user/info").validate().responseDecodable(of: UserInfo.self){ response in
            switch response.result {
            case .success(let user):
                self.pets = user.pets
                self.selectedPet = user.pets[0]
                self.loading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createInvite() {
        guard let pet = selectedPet else {
            return
        }
        
        savingState = .loading
        API.request("\(Config.API_URL)/invite/create/\(pet.id)", method: .post).validate().response { response in
            savingState = .success
            sheetShown = false
        }
    }
}

struct CreateInviteSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateInviteSheet(sheetShown: .constant(false))
    }
}
