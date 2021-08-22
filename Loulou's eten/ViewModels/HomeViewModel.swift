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
    
    @Published var sheetShown: Bool = false
    @Published var whichSheet: HomeSheet = .historySheet
    
    @Published var alertShown: Bool = false
    @Published var whichAlert: HomeAlert = .connectionError
    
    init() {
//        let hour = Calendar.current.component(.hour, from: Date())
//        breakfastOrDinner = hour < 12 ? "home.hasGotBreakfast" : "home.hasGotDinner"
    }
    
    func checkToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: "token") {
            return token
        } else {
            return nil
        }
    }
    
    func load() {
        if checkToken() == nil {
            return
        }
        
        API.request("\(Config.API_URL)/user/info").validate().responseDecodable(of: UserInfo.self) { response in
            switch response.result {
            case .success(let userInfo):
                self.userInfo = userInfo
                self.pets = userInfo.pets
                print(self.pets)
                if self.selectedPet == nil {
                    self.selectedPet = self.pets.first
                }
                
                if userInfo.pets.count == 1 {
                    self.showSheet(sheet: .welcomeSheet)
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
                print(error)
                self.showAlert(alert: .connectionError)
            }
        }
    }
    
    func showSheet(sheet: HomeSheet) {
        self.whichSheet = sheet
        self.sheetShown = true
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
        let isHost = url.host == "feed"
        
        if isDeepLink && isHost {
            API.request("\(Config.API_URL)/loulou/hasFood").validate().responseDecodable(of: HasFoodResponse.self) { response in
                switch response.result {
                case .success(let res):
                    if res.food == false {
                        self.showSheet(sheet: .feedingSheet)
                    } else {
                        self.showAlert(alert: .alreadyFed)
                    }
                    
                case .failure(let error):
                    print("error")
                    print(error)
                    self.showAlert(alert: .connectionError)
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
