//
//  ProductListModel.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//

import Foundation
import SwiftyJSON

class ProductListModel {

    let id: Int?
    let title: String?
    let price: Double?
    let description: String?
    let category: String?
    let image: String?
    let rating: Rating?
    // Custom properties for cart logic
     var quantity: Int = 1
     var isSelected: Bool = false

    init(_ json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        price = json["price"].doubleValue
        description = json["description"].stringValue
        category = json["category"].stringValue
        image = json["image"].stringValue
        rating = Rating(json["rating"])
    }

}
class Rating {

    let rate: Double?
    let count: Int?

    init(_ json: JSON) {
        rate = json["rate"].doubleValue
        count = json["count"].intValue
    }

}
