//
//  API.swift
//  API
//
//  Created by Wisse Hes on 16/08/2021.
//

import Foundation
import Alamofire

let API: Session = {
  let configuration = URLSessionConfiguration.af.default

    configuration.headers = [.authorization(Config.API_KEY)]
    
  return Session(configuration: configuration)
}()
