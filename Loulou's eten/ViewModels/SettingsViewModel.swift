//
//  SettingsViewModel.swift
//  SettingsViewModel
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var name: String {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "name") ?? ""
    }
}
