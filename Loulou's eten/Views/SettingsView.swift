//
//  SettingsView.swift
//  SettingsView
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        List {
            HStack {
                Label("general.name", systemImage: "person.fill")
                    .font(Font.body.bold())
                Spacer()
                TextField("general.name", text: $viewModel.name)
                    .multilineTextAlignment(.trailing)
            }
        }.navigationTitle("settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
