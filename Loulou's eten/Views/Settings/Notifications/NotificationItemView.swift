//
//  NotificationItemView.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 06/10/2021.
//

import SwiftUI
import Firebase
import FirebaseMessaging

struct NotificationItemView: View {
    
    @Binding var notification: NotificationResponseItem
    
    var body: some View {
        Section(notification.name) {
            HStack {
                Text("notification.on.fed \(notification.name)")
                
                Spacer()
                
                Toggle(notification.name, isOn: $notification.notification)
                    .labelsHidden()
                    .onTapGesture {
                        if notification.notification {
                            Messaging.messaging().unsubscribe(fromTopic: "\(notification.id)-fed")
                        } else {
                            Messaging.messaging().subscribe(toTopic: "\(notification.id)-fed")
                        }
                    }
            }
        }
        
    }
}

struct NotificationItemView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationItemView(notification: .constant(NotificationResponseItem(id: 1, name: "loulou", notification: true)))
    }
}
