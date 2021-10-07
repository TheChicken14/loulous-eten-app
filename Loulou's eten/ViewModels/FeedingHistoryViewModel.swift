//
//  FeedingHistoryViewModel.swift
//  FeedingHistoryViewModel
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation
import Alamofire
import SwiftUI

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
                    withAnimation {
                        self.feedingHistory = feedingHistory
                        self.loading = false
                        self.error = false
                        self.days = self.sortItems(feedingHistory)
                    }
                case .failure(_):
                    self.error = true
                }
            }
    }
    
    func sortItems(_ feedingHistory: [PetFeedingItem]) -> [PetFeedingDay] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var feedingDays: [PetFeedingDay] = []
        
        for feedingHistoryItem in feedingHistory {
            guard let date = feedingHistoryItem.whenDate else { continue }
            let dayString = dateFormatter.string(from: date)

            let dayItemIndex = feedingDays.firstIndex { day in
                return day.day == dayString
            }
            
            if let index = dayItemIndex, feedingDays.indices.contains(index) {
                feedingDays[index].feedingItems.append(feedingHistoryItem)
            } else {
                feedingDays.append(PetFeedingDay(day: dayString, feedingItems: [feedingHistoryItem]))
            }
        }
        
        return feedingDays
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
