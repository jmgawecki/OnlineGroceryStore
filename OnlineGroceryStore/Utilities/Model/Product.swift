//
//  Product.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import Foundation

struct Product: Hashable {
    let name: String
    let description: String?
    let price: Double
    let discounted: Bool
}

struct MockData {
    
    static let products: [Product] = [
        Product(name: "Toothpaste",  description: "This is a toothpaste", price: 1.30, discounted: false),
        Product(name: "Toothpaste2", description: "This is a toothpaste", price: 1.30, discounted: false),
        Product(name: "Toothpaste3", description: "This is a toothpaste", price: 1.30, discounted: false),
        Product(name: "Toothpaste4", description: "This is a toothpaste", price: 1.30, discounted: false),
        Product(name: "Toothpaste5", description: "This is a toothpaste", price: 1.30, discounted: false),
        Product(name: "Toothpaste6", description: "This is a toothpaste", price: 1.30, discounted: false),
        Product(name: "Toothpaste7", description: "This is a toothpaste", price: 1.30, discounted: false),

    ]
    
}
