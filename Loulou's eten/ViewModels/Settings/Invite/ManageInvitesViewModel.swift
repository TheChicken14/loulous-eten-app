//
//  ManageInvitesViewModel.swift
//  ManageInvitesViewModel
//
//  Created by Wisse Hes on 24/08/2021.
//

import Foundation

class ManageInvitesViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var error: Bool = false
    
    @Published var invites: [InviteItem] = []
    
    @Published var sheetShown: Bool = false {
        didSet {
            if !sheetShown {
                load()
            }
        }
    }
    
    func load() {
        API.request("\(Config.API_URL)/invite/list").validate().responseDecodable(of: [InviteItem].self) { response in
            switch response.result {
            case .success(let invites):
                self.invites = invites
                self.loading = false
                self.error = false
                
            case .failure(let error):
                print(error)
                self.error = true
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        let inviteCodes = offsets.map { self.invites[$0].invitationCode }
        
        for code in inviteCodes {
            let _ = API.request("\(Config.API_URL)/invite/delete/\(code)", method: .delete).validate().response { _ in  }
        }
        
        invites.remove(atOffsets: offsets)
    }
}
