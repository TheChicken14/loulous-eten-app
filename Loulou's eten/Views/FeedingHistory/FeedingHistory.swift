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
                
                ForEach(viewModel.feedingHistory, id: \.id) { item in
                    FeedingHistoryItemView(feedingItem: item)
                }
            }.navigationTitle("general.history")
                .onAppear(perform: viewModel.load)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            Picker("home.pet", selection: $viewModel.selectedPetIndex) {
                                ForEach(0..<viewModel.pets.count, id: \.self) { index in
                                    Text(viewModel.pets[index].name)
                                        .tag(index)
                                }
                            }
                        } label: {
                            Text(viewModel.selectedPet?.name ?? "home.pet")
                                .animation(.none)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.load()
                        } label: {
                            Label("home.reload", systemImage: "arrow.clockwise")
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
