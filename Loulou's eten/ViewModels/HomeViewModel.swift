//
//  HomeViewModel.swift
//  HomeViewModel
//
//  Created by Wisse Hes on 14/08/2021.
//

import Foundation
import Alamofire

class HomeViewModel: ObservableObject {
    
    @Published var loading: Bool = true
    @Published var giveFoodLoading: Bool = false
    
    @Published var userInfo: UserInfo?
    
    @Published var pets: [Pet] = []
    @Published var selectedPetIndex: Int = 0 {
        didSet {
            self.selectedPet = self.pets[selectedPetIndex]
        }
    }
    @Published var selectedPet: Pet? {
        didSet {
            getPetStatus()
        }
    }
    
    @Published var hasBreakfast: Bool = false
    @Published var breakfastItem: FoodItem?
    
    @Published var hasDinner: Bool = false
    @Published var dinnerItem: FoodItem?
    
    @Published var sheetShown: Bool = false {
        didSet {
            if !sheetShown {
                load(showLoading: false)
            }
        }
    }
    @Published var whichSheet: HomeSheet = .historySheet
    
    @Published var welcomeShown: Bool = false {
        didSet {
            if !welcomeShown {
                load(showLoading: true, shouldWelcome: false)
            }
        }
    }
    
    @Published var inviteCode = ""
    
    @Published var alertShown: Bool = false
    @Published var whichAlert: HomeAlert = .connectionError
    
    func checkToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "token") {
            return token
        } else {
            return nil
        }
    }
    
    func load(showLoading: Bool = false, shouldWelcome: Bool = true) {
        if checkToken() == nil {
            return
        }
        if showLoading {
            loading = true
        }
        
        API.request("\(Config.API_URL)/user/info").validate().responseDecodable(of: UserInfo.self) { response in
            switch response.result {
            case .success(let userInfo):
                self.userInfo = userInfo
                self.pets = userInfo.pets
                if self.selectedPet == nil {
                    self.selectedPet = self.pets.first
                }
                
                if userInfo.pets.count == 0 {
                    if shouldWelcome {
                        self.showSheet(sheet: .welcomeSheet)
                    }
                } else {
                    self.getPetStatus()
                }
                
            case .failure(let error):
                print(error)
                self.showAlert(alert: .connectionError)
            }
        }
    }
    
    func getPetStatus() {
        guard let petID = selectedPet?.id else {
            return;
        }
        
        API.request("\(Config.API_URL)/pet/status/\(petID)").validate().responseDecodable(of: PetStatus.self) {response in
            switch response.result {
            case .success(let petStatus):
                self.hasBreakfast = petStatus.morning != nil
                self.breakfastItem = petStatus.morning
                
                self.hasDinner = petStatus.evening != nil
                self.dinnerItem = petStatus.evening
                
                self.loading = false
                
            case .failure(let error):
                if error.responseCode == 404 {
                    self.selectedPet = nil
                    self.selectedPetIndex = 0
                    self.load()
                } else {
                    print(error)
                    self.showAlert(alert: .connectionError)
                }
            }
        }
    }
    
    func showSheet(sheet: HomeSheet) {
        if sheet == .welcomeSheet {
            self.welcomeShown = true
        } else {
            self.whichSheet = sheet
            self.sheetShown = true
        }
    }
    func showAlert(alert: HomeAlert) {
        self.whichAlert = alert
        self.alertShown = true
    }
    
    func giveFood() {
        showSheet(sheet: .feedingSheet)
    }
    
    func undoFood() {
        if checkToken() == nil {
            return
        }
        
        API.request("\(Config.API_URL)/loulou/undoFeeding", method: .delete).validate().response { response in
            switch response.result {
            case .success(_):
                self.load()
            case .failure(_):
                print("error")
                self.showAlert(alert: .connectionError)
            }
        }
    }
    
    func onOpenURL(url: URL) {
        let isDeepLink = url.scheme == "loulouapp"
        let isFeed = url.host == "feed"
        let isInvite = url.host == "invite"
        
        if isDeepLink {
            if isInvite {
                var code = url.path
                code.remove(at: code.startIndex)
                
                self.inviteCode = code
                //                self.showInviteView = true
                
                if welcomeShown {
                    welcomeShown = false
                    sheetShown = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.showSheet(sheet: .inviteSheet)
                    })
                } else {
                    showSheet(sheet: .inviteSheet)
                }
            }
            
            if isFeed {
                if url.path.isEmpty {
                    return;
                }
                var petID = url.path
                petID.remove(at: petID.startIndex)
                print(url.path)
                
                API.request("\(Config.API_URL)/pet/status/\(petID)").validate().responseDecodable(of: PetStatus.self) { response in
                    switch response.result {
                    case .success(let res):
                        let hour = Calendar.current.component(.hour, from: Date())
                        let isEvening = hour > 15
                        
                        if isEvening && res.evening != nil {
                            // already fed
                            self.showAlert(alert: .alreadyFed)
                        } else if !isEvening && res.morning != nil {
                            // already fed
                            self.showAlert(alert: .alreadyFed)
                        } else {
                            // show feeding sheet
                            guard let petIDInt = Int(petID) else {
                                return
                            }
                            
                            if let petIndex = self.pets.firstIndex(where: { $0.id == petIDInt}) {
                                self.selectedPetIndex = petIndex
                                self.showSheet(sheet: .feedingSheet)
                            }
                        }
                        
                        
                    case .failure(let error):
                        print("error")
                        print(error)
                        
                        if error.responseCode == 401 || error.responseCode == 404 {
                            self.showAlert(alert: .noPermission)
                        } else {
                            self.showAlert(alert: .connectionError)
                        }
                    }
                }
            }
        }
    }
    
    func onSheetDismiss() {
        if whichSheet == .feedingSheet {
            load()
        }
    }
}
