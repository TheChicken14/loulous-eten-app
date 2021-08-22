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
    
    private var deletingIndexes: [Int] = []
    
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
    
    func delete(at offsets: IndexSet) {
        deletingIndexes = offsets.map { $0 }
        
        showAlert(alert: .areYouSure)
        print(offsets)
    }
    
    func imSure() {
        for index in deletingIndexes {
            print(index)
        }
    }
    
    func showAlert(alert: ManagePetAlert) {
        self.whichAlert = alert
        self.alertShown = true
    }
}
