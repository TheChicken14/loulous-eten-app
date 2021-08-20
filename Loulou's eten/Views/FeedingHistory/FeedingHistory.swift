//
//  FeedingHistory.swift
//  FeedingHistory
//
//  Created by Wisse Hes on 16/08/2021.
//

import SwiftUI

struct FeedingHistory: View {
    
    @StateObject var viewModel = FeedingHistoryViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.loading {
                    List(viewModel.history, id: \._id) { item in
                        FeedingHistoryItemView(historyItem: item)
                            .contextMenu {
                                Button {
                                    viewModel.removeItem(item: item)
                                } label: {
                                    Label("feedingHistory.remove", systemImage: "trash")
                                }
                            }
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }.navigationTitle("general.feedingHistory").onAppear(perform: viewModel.load).toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("general.close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.secondLoading {
                        ProgressView()
                    }
                }
            }
        }
    }
}

struct FeedingHistory_Previews: PreviewProvider {
    static var previews: some View {
        FeedingHistory()
    }
}
