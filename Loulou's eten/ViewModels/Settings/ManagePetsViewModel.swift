//
//  ManagePetsViewModel.swift
//  ManagePetsViewModel
//
//  Created by Wisse Hes on 22/08/2021.
//

import Foundation

class ManagePetsViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    
    @Published var alertShown: Bool = false
    @Published var whichAlert: ManagePetAlert = .connectionError
    
    private var deletingIndex: Int = 0
    
    init() {
        load()
    }
    
    func load() {
        API.request("\(Config.API_URL)/user/info").validate().responseDecodable(of: UserInfo.self) { response in
            switch response.result {
            case .success(let userInfo):
                self.pets = userInfo.pets
                                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func delete(index: IndexSet) {
        deletingIndex = index.first ?? 0
        showAlert(alert: .areYouSure)
        print(index)
    }
    
    func imSure() {
        
    }
    
    func showAlert(alert: ManagePetAlert) {
        self.whichAlert = alert
        self.alertShown = true
    }
}
