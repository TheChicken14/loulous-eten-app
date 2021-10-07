//
//  NotificationsResponse.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 06/10/2021.
//

import Foundation

typealias NotificationsResponse = [NotificationResponseItem]

struct NotificationResponseItem: Codable {
    var id: Int
    var name: String
    var notification: Bool
}
