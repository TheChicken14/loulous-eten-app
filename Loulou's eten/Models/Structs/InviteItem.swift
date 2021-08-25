//
//  InviteItem.swift
//  InviteItem
//
//  Created by Wisse Hes on 24/08/2021.
//

import Foundation

struct InviteItem: Codable {
    let id: Int
    let invitationCode: String
    let from: InviteFrom
    let pet: Pet
}

struct InviteFrom: Codable {
    let name: String
}
