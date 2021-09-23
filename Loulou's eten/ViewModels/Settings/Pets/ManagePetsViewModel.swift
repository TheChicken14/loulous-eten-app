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
    
    private var deletingIndexes: IndexSet?
    
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
        deletingIndexes = offsets
        
        showAlert(alert: .areYouSure)
        print(offsets)
    }
    
    func imSure() {
        guard let indexSet = deletingIndexes else {
            return
        }
        
        let ids = indexSet.map { self.pets[$0].id }
        
        for id in ids {
            API.request("\(Config.API_URL)/pet/delete/\(id)", method: .delete).validate().response { _ in }
        }
        
        self.pets.remove(atOffsets: indexSet)
    }
    
    func showAlert(alert: ManagePetAlert) {
        self.whichAlert = alert
        self.alertShown = true
    }
}
