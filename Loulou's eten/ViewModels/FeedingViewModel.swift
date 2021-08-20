//
//  FeedingViewModel.swift
//  FeedingViewModel
//
//  Created by Wisse Hes on 17/08/2021.
//

import Foundation
import Alamofire
import Combine
import UIKit

class FeedingViewModel: ObservableObject {
    @Published var buttonState: ButtonState = .normal
    
    @Published var date = Date()
    @Published var feedingType: FeedingType = .morning
    @Published var byName = ""
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    init() {
        self.byName = UserDefaults.standard.string(forKey: "name") ?? ""
        
        let hour = Calendar.current.component(.hour, from: Date())
        self.feedingType = hour > 12 ? .evening : .morning
    }
    
    func haptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func feed() {
        buttonState = .loading
        let params = RequestParameters(name: byName, date: date, type: feedingType.rawValue)
        let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(dateEncoding: .iso8601))
        
        API.request(
            "\(Config.API_URL)/loulou/giveFood",
            method: .post,
            parameters: params,
            encoder: encoder
        ).validate().response { response in
            self.buttonState = .success
            self.haptic()
            
            switch response.result {
            case .success(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.shouldDismissView = true
                }
            case .failure(let error):
                print("error")
                print(error)
            }
        }
    }
}
