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
    
    @Published var hasFood: Bool = false
    @Published var whenGotFood: Date? = Date()
    @Published var feeder: String? = ""
    
    @Published var sheetShown: Bool = false
    @Published var whichSheet: HomeSheet = .historySheet
    
    @Published var alertShown: Bool = false
    @Published var whichAlert: HomeAlert = .connectionError
    
    @Published var breakfastOrDinner: String
    
    init() {
        let hour = Calendar.current.component(.hour, from: Date())
        breakfastOrDinner = hour < 12 ? "home.hasGotBreakfast" : "home.hasGotDinner"
    }
    
    func checkName() -> String? {
        if let name = UserDefaults.standard.string(forKey: "name") {
            return name
        } else {
            showSheet(sheet: .welcomeSheet)
            return nil
        }
    }
    
    func load() {
        let _ = checkName()
    
        API.request("\(Config.API_URL)/loulou/hasFood").validate().responseDecodable(of: HasFoodResponse.self) { response in
            self.loading = false
            self.giveFoodLoading = false
            
            switch response.result {
            case .success(let res):
                self.hasFood = res.food
                self.whenGotFood = res.whenDate
                self.feeder = res.by
                
            case .failure(let error):
                print("error")
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
        if checkName() == nil {
            return;
        }
        
        showSheet(sheet: .feedingSheet)
    }
    
    func undoFood() {
        if checkName() == nil {
            return;
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
