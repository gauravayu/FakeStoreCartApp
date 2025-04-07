//
//  APIManager.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

// DataManager.swift

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    class func alamofireGetRequest(
        urlString: String,
        completion: @escaping (JSON?, Error?) -> Void
    ) {
        AF.request(urlString, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let json = try JSON(data: data)
                    completion(json, nil)
                } catch {
                    print("SwiftyJSON Parsing Error: \(error)")
                    completion(nil, error)
                }

            case .failure(let error):
                print("API Request Error: \(error)")
                completion(nil, error)
            }
        }
    }
}
