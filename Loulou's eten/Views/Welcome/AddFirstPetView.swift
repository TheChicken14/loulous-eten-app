//
//  AddFirstPetView.swift
//  AddFirstPetView
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI

struct AddFirstPetView: View {
    @State var name = ""
    @State var nextScreenActive = false
    @Binding var sheetShown: Bool
    
    var body: some View {
        NavigationLink(destination: FirstPetDoneView(name: name, sheetShown: $sheetShown), isActive: $nextScreenActive) {
            EmptyView()
        }
        List {
            Text("Vul hier de naam van je huisdier in")
                .bold()
            
            HStack {
                Text("general.name")
                    .bold()
                Spacer()
                TextField(
                    LocalizedStringKey("general.name"),
                    text: $name
                )
                    .multilineTextAlignment(.trailing)
            }
            
            Button("welcome.done") {
                nextScreenActive = true
            }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).count == 0)
        }.navigationTitle("Huisdier toevoegen")
    }
}

struct AddFirstPetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddFirstPetView(sheetShown: .constant(true))
        }
    }
}
