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
                ForEach(viewModel.days, id: \.id) { day in
                    Section() {
                        ForEach(day.feedingItems, id: \.id) { item in
                            FeedingHistoryItemView(feedingItem: item)
                        }
                    } header: {
                        Text("\(day.day, style: .date)")
                    }
                }
                
                if viewModel.feedingHistory.count == 0 && !viewModel.loading {
                    HStack {
                        Spacer()
                        Text("Nog niks!")
                        Spacer()
                    }
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
                        if viewModel.loading {
                            ProgressView()
                        } else {
                            Button {
                                viewModel.reloadButtonPress()
                            } label: {
                                Label("home.reload", systemImage: "arrow.clockwise")
                            }.disabled(viewModel.reloadButtonDisabled)
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
