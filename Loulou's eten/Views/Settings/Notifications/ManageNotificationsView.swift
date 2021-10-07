//
//  ManageNotificationsView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 05/10/2021.
//

import SwiftUI

struct ManageNotificationsView: View {
    
    @StateObject var viewModel = ManageNotificationsViewModel()
    
    var body: some View {
        Group {
            if viewModel.loading {
                ProgressView()
            } else {
                list
            }
        }.navigationTitle("notifications").onAppear(perform: viewModel.load)
    }
    
    var list: some View {
        List {
            ForEach($viewModel.notifications, id: \.id) { item in
                NotificationItemView(notification: item)
            }
        }
    }
    
}

struct ManageNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageNotificationsView()
    }
}
