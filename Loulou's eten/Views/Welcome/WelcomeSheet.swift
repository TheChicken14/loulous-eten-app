//
//  WelcomeSheet.swift
//  WelcomeSheet
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct WelcomeSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var sheetShown: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("welcome.header")
                    .font(.title)
                    .padding()
                Text("welcome.subheader")
                    .padding()
                
                NavigationLink("welcome.addFirstPet") {
                    AddFirstPetView(sheetShown: $sheetShown)
                }
                
                Spacer()
            }.navigationTitle("welcome.title")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet(sheetShown: .constant(true))
    }
}
