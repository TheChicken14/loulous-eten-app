//
//  FeedingRequestParams.swift
//  FeedingRequestParams
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation

struct FeedingRequestParams: Codable {
    let id: Int
    let date: Date
    let type: FeedingType.RawValue
}
