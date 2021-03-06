//
//  Constants.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

enum imageAsUIImage {
    static let shopBuilding             = UIImage(named: "shopBuilding")
    static let shoppingLadyr071         = UIImage(named: "shoppingLadyr071")
    static let shoppingLadyr056         = UIImage(named: "shoppingLadyr056")
    static let wavingPeopleR088         = UIImage(named: "wavingPeopleR088")
    static let shoppingPerson3R079      = UIImage(named: "shoppingPerson3R079")
    static let angryBlackGirlR056       = UIImage(named: "angryBlackGirlR056")
    static let concernedBlackGirlR056   = UIImage(named: "concernedBlackGirlR056")
    static let happyBlackGirlR056       = UIImage(named: "happyBlackGirlR056")
    static let sadBlackGirlR056         = UIImage(named: "sadBlackGirlR056")
    static let smilingBlackGirlR065     = UIImage(named: "smilingBlackGirlR065")
    static let wavingBlackGirlR056      = UIImage(named: "wavingBlackGirlR056")
    static let foodPlaceholder          = UIImage(named: "foodPlaceholder")
    static let xmark                    = UIImage(named: "xmark")
    
}

enum AlertImage {
    static let angryBlackGirlR056       = UIImage(named: "angryBlackGirlR056")
    static let concernedBlackGirlR056   = UIImage(named: "concernedBlackGirlR056")
    static let happyBlackGirlR056       = UIImage(named: "happyBlackGirlR056")
    static let sadBlackGirlR056         = UIImage(named: "sadBlackGirlR056")
    static let smilingBlackGirlR065     = UIImage(named: "smilingBlackGirlR065")
}

enum AlertMessages {
    static let checkInternet            = "We couldn't make that happen.. Please check your internet connection"
}

enum systemImageAsUIImage {
    static let plusLarge                = UIImage(systemName: "plus",
                                                  withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    static let minusLarge               = UIImage(systemName: "minus",
                                                  withConfiguration: UIImage.SymbolConfiguration(scale: .large))
}


enum colorAsUIColor {
    static let storeBackground          = UIColor(named: "storeBackground")
    static let storeSecondaryBackground = UIColor(named: "storeSecondaryBackground")
    static let storeSecondary           = UIColor(named: "storeSecondary")
    static let storeTertiary            = UIColor(named: "storeTertiary")
    static let storePrimaryText         = UIColor(named: "storePrimaryText")
}

//
//enum colorAsString {
//    static let storeBackground          = "storeBackground"
//    static let storeSecondary           = "storeSecondary"
//    static let storeTertiary            = "storeTertiary"
//    static let storePrimaryText         = "storePrimaryText"
//}


enum systemImageAsString {
    static let search                   = "magnifyingglass"
    static let favorites                = "suit.heart"
    static let home                     = "house"
    static let orders                   = "bag"
    static let basket                   = "cart"
}
