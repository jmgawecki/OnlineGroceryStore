//
//  Order.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 02/03/2021.
//

import Foundation

struct Order: Codable, Hashable {
    let orderNumber: String
    let date: String
    let products: [ProductLocal]
}
