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
    @Published var secondLoading: Bool = false
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
    
    func removeItem(item: HistoryItem) {
        secondLoading = true
        
        let params = RemoveItemParams(_id: item._id)
        API.request(
            "\(Config.API_URL)/loulou/removeItem",
            method: .delete,
            parameters: params
        ).validate().response { response in
            self.secondLoading = false
            switch response.result {
            case .success(_):
                self.load()
            case .failure(_):
                print("error")
            }
        }
    }
}
