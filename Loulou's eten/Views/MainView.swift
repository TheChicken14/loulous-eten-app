//
//  MainView.swift
//  MainView
//
//  Created by Wisse Hes on 22/08/2021.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Label("home.name", systemImage: "house")
                }
            
            FeedingHistory()
                .tabItem {
                    Label("general.feedingHistory", systemImage: "clock")
                }
        }.navigationViewStyle(.stack)
            .onOpenURL(perform: { url in
                viewModel.onOpenURL(url: url)
            })
            .fullScreenCover(isPresented: $viewModel.showLoginView, content: {
                LoginScreen(loading: viewModel.isLoading)
            })
            .alert(isPresented: $viewModel.errorAlert) {
                Alert(
                    title: Text("alert.somethingWrong.title"),
                    message: Text("alert.somethingWrong.message"),
                    dismissButton: .cancel(Text("general.ok"))
                )
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
