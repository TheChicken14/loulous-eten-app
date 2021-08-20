//
//  FeedingHistoryViewModel.swift
//  FeedingHistoryViewModel
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation
import Alamofire

class FeedingHistoryViewModel: ObservableObject {
    @Published var loading: Bool = true
    @Published var history: [HistoryItem] = []
    
    func load() {
        API.request("\(Config.API_URL)/loulou/history").validate().responseDecodable(of: HistoryResponse.self) { response in
            self.loading = false

            switch response.result {
            case .success(let res):
                self.history = res.history.reversed()
            case .failure(let error):
                print("error")
                print(error)
            }
        }
    }
}
