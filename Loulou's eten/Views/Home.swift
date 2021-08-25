//
//  Home.swift
//  Home
//
//  Created by Wisse Hes on 14/08/2021.
//

import SwiftUI
import Combine

struct Home: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = HomeViewModel()
    
    var reloadPublisher: PassthroughSubject<Bool, Never>
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                if !viewModel.loading {
                    VStack {
                        if let pet = viewModel.selectedPet {
                            AdaptiveStack {
                                Spacer()
                                HasFoodView(
                                    type: .morning,
                                    hasFood: viewModel.hasBreakfast,
                                    feedingItem: viewModel.breakfastItem,
                                    pet: pet
                                )
                                Spacer()
                                Divider()
                                Spacer()
                                HasFoodView(
                                    type: .evening,
                                    hasFood: viewModel.hasDinner,
                                    feedingItem: viewModel.dinnerItem,
                                    pet: pet
                                )
                                Spacer()
                            }
                        }
                        
                        if !viewModel.hasBreakfast || !viewModel.hasDinner {
                            Button {
                                viewModel.giveFood()
                            } label: {
                                switch viewModel.giveFoodLoading {
                                case true:
                                    ProgressView()
                                case false:
                                    ButtonLabel(
                                        title: "home.fedButton",
                                        imageName: "person.fill.checkmark",
                                        color: .green
                                    )
                                }
                            }
                        }
                    }
                }
                
                if viewModel.loading {
                    LoadingView()
                }
                
            }.onAppear(perform: { viewModel.load(showLoading: false) }).navigationTitle("home.name")
                .sheet(isPresented: $viewModel.sheetShown, onDismiss: viewModel.onSheetDismiss){
                    switch viewModel.whichSheet {
                    case .historySheet:
                        FeedingHistory()
                    case .welcomeSheet:
                        EmptyView()
                    case .feedingSheet:
                        if let pet = viewModel.selectedPet {
                            FeedingSheet(pet: pet)
                        }
                    }
                }
                .fullScreenCover(isPresented: $viewModel.welcomeShown, content: { WelcomeSheet(sheetShown: $viewModel.welcomeShown) })
                .alert(isPresented: $viewModel.alertShown) {
                    switch viewModel.whichAlert {
                    case .alreadyFed:
                        return Alert(
                            title: Text("alert.alreadyFed.title"),
                            dismissButton: .cancel(Text("general.ok"))
                        )
                    case .connectionError:
                        return Alert(
                            title: Text("alert.noConnection.title"),
                            message: Text("alert.noConnection.message"),
                            dismissButton: .cancel(Text("general.ok"))
                        )
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()) {
                            Label("settings", systemImage: "gear")
                                .foregroundColor(
                                    colorScheme == ColorScheme.dark
                                    ? .white
                                    : .black
                                )
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if !viewModel.loading {
                            Menu {
                                Picker("home.pet", selection: $viewModel.selectedPetIndex) {
                                    ForEach(0..<viewModel.pets.count, id: \.self) { i in
                                        Text(viewModel.pets[i].name)
                                            .tag(i)
                                    }
                                }
                            } label: {
                                Text(viewModel.selectedPet?.name ?? "home.pet")
                                    .animation(.none)
                                    .foregroundColor(
                                        colorScheme == ColorScheme.dark
                                        ? .white
                                        : .black
                                    )
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.load(showLoading: true)
                        } label: {
                            Label("home.reload", systemImage: "arrow.clockwise")
                                .foregroundColor(
                                    colorScheme == ColorScheme.dark
                                    ? .white
                                    : .black
                                )
                        }
                    }
                }
                .onOpenURL { url in
                    viewModel.onOpenURL(url: url)
                }
                .onReceive(reloadPublisher) { output in
                    viewModel.load()
                }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        Spacer()
        ProgressView()
            .ignoresSafeArea()
            .frame(alignment: .center)
            .progressViewStyle(CircularProgressViewStyle())
            .padding(25)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
        Spacer()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Home(reloadPublisher: PassthroughSubject<Bool, Never>())
        }
    }
}
