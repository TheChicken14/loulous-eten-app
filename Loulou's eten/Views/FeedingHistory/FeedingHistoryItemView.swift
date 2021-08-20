//
//  FeedingHistoryItemView.swift
//  FeedingHistoryItemView
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct FeedingHistoryItemView: View {
    let historyItem: HistoryItem
    
    var body: some View {
        VStack(alignment:.leading) {
            if let date = historyItem.whenDate {
                Text("feedingHistory.dateAt \(date, style: .date) \(date, style: .time)")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack {
                    Text("feedingHistory.by \(historyItem.by)")
                    
                    Spacer()
                    
                    switch historyItem.type {
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
