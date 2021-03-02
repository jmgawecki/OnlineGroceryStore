//
//  ProductMockData.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.


import Foundation

struct ProductLocal: Hashable {
    let name: String
    let description: String?
    let price: Double
    let favorite: Bool
    let category: String
    let imageReference: String
    let id: String
    let discountMlt: Double
    let tag: [String]
    let topOffer: Bool
    let quantity: Int
}

