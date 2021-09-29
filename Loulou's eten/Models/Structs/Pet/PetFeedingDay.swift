//
//  PetFeedingDay.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 28/09/2021.
//

import Foundation

struct PetFeedingDay: Identifiable {
    let day: Date
    var feedingItems: [PetFeedingItem]
    
    var id = UUID()
}
