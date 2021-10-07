//
//  ManageNotificationsViewModel.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 05/10/2021.
//

import Foundation
import Firebase
import FirebaseMessaging
import UIKit

final class ManageNotificationsViewModel: ObservableObject {
    @Published var loading: Bool = true
    
    @Published var notifications: [NotificationResponseItem] = []
    
    func load() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
            
        API.request("\(Config.API_URL)/notifications/all/\(uuid)").validate().responseDecodable(of: NotificationsResponse.self) { response in
            self.loading = false
            switch response.result {
            case .success(let notifications):
                self.notifications = notifications
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func subscribe(pet: Pet) {
        Messaging.messaging().subscribe(toTopic: "\(pet.id)-fed")
    }
    
    func unsubscribe(pet: Pet) {
        Messaging.messaging().unsubscribe(fromTopic: "\(pet.id)-fed")
    }
}
