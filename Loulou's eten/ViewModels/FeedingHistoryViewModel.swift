//
//  FeedingHistoryViewModel.swift
//  FeedingHistoryViewModel
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation
import Alamofire

class FeedingHistoryViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var error: Bool = false

    @Published var reloadButtonDisabled: Bool = false
    
    @Published var pets: [Pet] = []
    @Published var selectedPetIndex: Int = 0 {
        didSet {
            self.selectedPet = self.pets[selectedPetIndex]
        }
    }
    @Published var selectedPet: Pet? {
        didSet {
            if let pet = selectedPet {
                self.loadFoodHistory(pet: pet)
            }
        }
    }
    
    @Published var feedingHistory: [PetFeedingItem] = []
    @Published var days: [PetFeedingDay] = []
    
    func reloadButtonPress() {
        loading = true
        reloadButtonDisabled = true
        
        load()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { self.reloadButtonDisabled = false })
    }
    
    func load() {
        loadPets()
    }
    
    func loadPets() {
        API.request("\(Config.API_URL)/user/info").responseDecodable(of: UserInfo.self) { response in
            switch response.result {
            case .success(let userinfo):
                self.pets = userinfo.pets
                self.error = false
                
                if self.selectedPet == nil {
                    if let firstPet = self.pets.first {
                        self.selectedPet = firstPet
                    }
                } else if let selectedPet = self.selectedPet {
                    self.loadFoodHistory(pet: selectedPet)
                }
            case .failure(_):
                self.error = true
            }
        }
    }
    
    func loadFoodHistory(pet: Pet) {
        self.days = []
        API.request(
            "\(Config.API_URL)/food/history/\(selectedPet?.id ?? 0)"
        )
            .responseDecodable(of: [PetFeedingItem].self) { response in
                switch response.result {
                case .success(let feedingHistory):
                    self.feedingHistory = feedingHistory
                    self.loading = false
                    self.error = false
                    
                    for feedingHistoryItem in feedingHistory {
                        guard let date = feedingHistoryItem.whenDate else { return }
                        
                        let dayItemIndex = self.days.firstIndex { day in
                            let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
                            let dayComponents = Calendar.current.dateComponents([.day, .month, .year], from: day.day)
                            
                            if dateComponents.day == dayComponents.day &&
                                dateComponents.month == dayComponents.month &&
                                dateComponents.year == dayComponents.year {
                                return true
                            } else {
                                return false
                            }
                        }
                        guard let index = dayItemIndex else {
                            self.days.append(PetFeedingDay(day: date, feedingItems: [feedingHistoryItem]))
                            continue;
                        }
                        
                        if self.days.indices.contains(index) {
                            self.days[index].feedingItems.append(feedingHistoryItem)
                        } else {
                            self.days.append(PetFeedingDay(day: date, feedingItems: [feedingHistoryItem]))
                        }
                    }
                    
                case .failure(_):
                    self.error = true
                }
            }
    }
    
    func removeItem(item: HistoryItem) {
        let params = RemoveItemParams(_id: item._id)
        
        API.request(
            "\(Config.API_URL)/loulou/removeItem",
            method: .delete,
            parameters: params
        ).validate().response { response in
            switch response.result {
            case .success(_):
                self.load()
            case .failure(_):
                print("error")
            }
        }
    }
}
