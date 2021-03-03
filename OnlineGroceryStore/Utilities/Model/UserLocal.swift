//
//  User.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import Foundation

struct UserLocal: Codable, Hashable {
    let uid:        String
    let firstName:  String
    let lastName:   String
    let email:      String
}
