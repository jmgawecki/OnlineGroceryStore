//
//  ProductMockData.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import Foundation

struct Product: Hashable {
    let name: String
    let description: String?
    let price: Double
    let favorite: Bool
    let category: String
    let imageReference: String
    let id: String
    let discountMlt: Double
    let tag: [String]
}

