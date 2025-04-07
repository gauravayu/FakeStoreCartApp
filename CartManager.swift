//
//  CartManager.swift
//  FakeStoreApp
//
//  Created by Gaurav Agnihotri on 07/04/25.
//


import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}

    var cartItems: [ProductListModel] = []

    func addToCart(_ product: ProductListModel) {
        cartItems.append(product)
    }

    func getCartItems() -> [ProductListModel] {
        return cartItems
    }
    func clearCart() {
           cartItems.removeAll()
       }
    func removeFromCart(_ product: ProductListModel) {
          cartItems.removeAll { $0.id == product.id }
      }
}
