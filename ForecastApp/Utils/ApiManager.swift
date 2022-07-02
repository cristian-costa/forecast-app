//
//  ApiManager.swift
//  ForecastApp
//
//  Created by Cristian Costa on 02/07/2022.
//

import Foundation
import Alamofire

struct ApiManager{
    
    static let shared = ApiManager()
    
    private init(){}
    
    func get(url: String, completion: @escaping (Result<Data?, AFError>) -> () ){
        AF.request(url).response { response in
            completion(response.result)
        }
    }
   
}

