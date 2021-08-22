//
//  HasFoodView.swift
//  HasFoodView
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI

struct HasFoodView: View {
    var type: FeedingType
    var hasFood: Bool
    var feedingItem: FoodItem?
    var pet: Pet
    
    var body: some View {
        VStack {
            Text(
                type == .morning
                ? "home.hasGotBreakfast \(pet.name)"
                : "home.hasGotDinner \(pet.name)"
            )
                .font(.headline)
            
            Label(
                hasFood ? "home.food.yes" : "home.food.no",
                systemImage: hasFood ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding(35)
            
            if hasFood {
                if let date = feedingItem?.whenDate, let name = feedingItem?.by.name {
                    Text("home.fedByOnTime \(date, style: .time) \(name)")
                        .font(.title2)
                        .padding()
                }
            }
        }
    }
}

//struct HasFoodView_Previews: PreviewProvider {
//    static var previews: some View {
//        HasFoodView()
//    }
//}
