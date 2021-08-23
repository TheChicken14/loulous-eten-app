//
//  FeedingHistoryItemView.swift
//  FeedingHistoryItemView
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct FeedingHistoryItemView: View {
    let feedingItem: PetFeedingItem
    
    var body: some View {
        VStack(alignment:.leading) {
            if let date = feedingItem.whenDate {
                Text("feedingHistory.dateAt \(date, style: .date) \(date, style: .time)")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack {
                    Text("feedingHistory.by \(feedingItem.by.name)")
                    
                    Spacer()
                    
                    switch feedingItem.type {
                    case .morning:
                        Text("feeding.type.morning")
                    case .evening:
                        Text("feeding.type.evening")
                    }
                }
            }
        }
    }
}

//struct FeedingHistoryItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedingHistoryItemView()
//    }
//}
