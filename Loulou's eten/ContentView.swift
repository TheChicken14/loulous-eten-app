//
//  ContentView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 14/08/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        NavigationView {
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
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
