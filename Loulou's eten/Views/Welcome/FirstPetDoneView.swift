//
//  FirstPetDoneView.swift
//  FirstPetDoneView
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI

struct FirstPetDoneView: View {
    
    var petProfile: CreatePetProfileData
    
    @Binding var sheetShown: Bool

    @StateObject var viewModel = AddFirstPetViewModel()
    
    var body: some View {
        VStack {
            if viewModel.loading {
//            if false {
                ProgressView()
            } else {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                Text("welcome.done")
                    .font(.largeTitle)
                    .padding()
                
                Button("general.close") {
                    sheetShown = false
                }
            }
        }.onAppear {
            viewModel.addPet(petProfile: petProfile)
        }
    }
}

struct FirstPetDoneView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FirstPetDoneView(petProfile: CreatePetProfileData(
                name: "",
                birthdate: Date(),
                morningFood: "",
                dinnerFood: "",
                extraNotes: ""
            ) ,sheetShown: .constant(true))
        }
    }
}
