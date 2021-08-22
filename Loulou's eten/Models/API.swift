//
//  API.swift
//  API
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation
import Alamofire

final class RequestInterceptor: Alamofire.RequestInterceptor {

//    private let storage: AccessTokenStorage
//
//    init(storage: AccessTokenStorage) {
//        self.storage = storage
//    }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Config.API_URL) == true else {
            /// If the request does not require authentication, we can directly return it as unmodified.
            return completion(.success(urlRequest))
        }
        var urlRequest = urlRequest

        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        /// Set the Authorization header value using the access token.
        urlRequest.setValue(token, forHTTPHeaderField: "authorization")

        completion(.success(urlRequest))
    }
}

let API: Session = {
  let configuration = URLSessionConfiguration.af.default

    configuration.headers = [.authorization(Config.API_KEY)]
    
  return Session(configuration: configuration, interceptor: RequestInterceptor())
}()
