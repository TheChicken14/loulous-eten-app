//
//  SIWAParams.swift
//  SIWAParams
//
//  Created by Wisse Hes on 24/08/2021.
//

import Foundation

struct SIWAParams: Codable {
    let token: String
    let appleID: String
    
    let email: String?
    let givenName: String?
    let familyName: String?
}
