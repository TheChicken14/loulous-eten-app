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
            List {
                if viewModel.loading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                
                ForEach(viewModel.history, id: \._id) { item in
                    FeedingHistoryItemView(historyItem: item)
                        .contextMenu {
                            Button {
                                viewModel.removeItem(item: item)
                            } label: {
                                Label("feedingHistory.remove", systemImage: "trash")
                            }
                        }
                }
            }.navigationTitle("general.history").onAppear(perform: viewModel.load).toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.load()
                    } label: {
                        Label("home.reload", systemImage: "arrow.clockwise")
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
