//
//  WelcomeSheet.swift
//  WelcomeSheet
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct WelcomeSheet: View {
    
    @StateObject var viewModel = WelcomeViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("welcome.header")
                    .font(.title)
                    .padding()
                Text("welcome.subheader")
                    .padding()
                HStack {
                    Text("welcome.whatsYourName")
                        .bold()
                    TextField(
                        LocalizedStringKey("general.name"),
                        text: $viewModel.name
                    ).multilineTextAlignment(.trailing)
                }.frame(width: 280, height: 50)
                
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.saveName()
                    } label: {
                        Label("general.done", systemImage: "checkmark.circle")
                    }
                }
            }.onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
                if shouldDismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct WelcomeSheet_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSheet()
    }
}
