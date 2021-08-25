//
//  MainView.swift
//  MainView
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI
import Combine

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        TabView {
            Home(reloadPublisher: viewModel.reloadPublisher)
                .tabItem {
                    Label("home.name", systemImage: "house")
                }
            
            FeedingHistory()
                .tabItem {
                    Label("general.feedingHistory", systemImage: "clock")
                }
        }.navigationViewStyle(.stack)
            .fullScreenCover(isPresented: $viewModel.showLoginView, content: {
                LoginScreen(isLoggedIn: $viewModel.isLoggedIn)
            })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
