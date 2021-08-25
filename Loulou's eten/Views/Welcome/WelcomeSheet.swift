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
                
                NavigationLink {
                    AddFirstPetView(sheetShown: $sheetShown)
                } label: {
                    NavButtonLabel(label: "welcome.addFirstPet")
                }.buttonStyle(.plain)
                
                NavigationLink {
                    HowToAcceptInvite()
                } label: {
                    NavButtonLabel(label: "welcome.addWithInvite")
                }.buttonStyle(.plain)
                
                Spacer()
            }.navigationTitle("welcome.title")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NavButtonLabel: View {
    
    var label: LocalizedStringKey
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(label)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.forward")
            
            Spacer()
        }.foregroundColor(.white)
            .frame(width: 280, height: 50)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet(sheetShown: .constant(true))
    }
}
