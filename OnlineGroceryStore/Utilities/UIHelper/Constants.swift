//
//  Constants.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit


// MARK: - Custom Image


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


enum systemImageAsString {
    static let search                   = "magnifyingglass"
    static let favorites                = "suit.heart"
    static let home                     = "house"
    static let orders                   = "bag"
    static let basket                   = "cart"
}


// MARK: - Store Alert


enum AlertTitle: String {
    case success                        = "Horray!"
    case failure                        = "Oops"
}


enum AlertMessages: String {
    case checkInternet                  = "We couldn't make that happen.. Please check your internet connection"
    case emptyBasket                    = "Seem like you haven't add any products! Add some with the + button and try again."
    case itemAddedToBasket              = "You have succesfully added an item to your basket"
    case orderAddedToBasket             = "You have succesfully added last order to your basket."
    case basketIsEmpty                  = "Looks like the basket is empty! Add some products"
    case orderPlaced                    = "You have succesfully placed your order!"
    case quantityUpdated                = "Item's quantity successfully updated!"
    case addSomeQuantity                = "Seem like you haven't add any products! Add some with the + button and try again.."
    case passwordsArentMatching         = "Password are not matching! Please make sure both password are correct."
    case passwordBadFormat              = "Password is not valid. Please make sure that the password inlcudes: capital letter, 1 number, 1 special character and at least 8 characters"
    case signUpFillAllFields            = "Seems like you haven't field all fields. Please make sure that all the fields are correct"
}


enum AlertButtonTitle: String {
    case ok                             = "Ok"
    case willDo                         = "Will do"
}


enum AlertImage {
    case angryBlackGirlR056
    case concernedBlackGirlR056
    case happyBlackGirlR056
    case sadBlackGirlR056
    case smilingBlackGirlR065
}

extension AlertImage: RawRepresentable {
    typealias RawValue = UIImage

    init?(rawValue: RawValue) {
        switch rawValue {
        case UIImage(named: "angryBlackGirlR056"): self         = .angryBlackGirlR056
        case UIImage(named: "concernedBlackGirlR056"): self     = .concernedBlackGirlR056
        case UIImage(named: "happyBlackGirlR056"): self         = .happyBlackGirlR056
        case UIImage(named: "sadBlackGirlR056"): self           = .sadBlackGirlR056
        case UIImage(named: "smilingBlackGirlR065"): self       = .smilingBlackGirlR065
        default: return nil
        }
    }

    var rawValue: RawValue {
        switch self {
        case .angryBlackGirlR056:       return UIImage(named: "angryBlackGirlR056")!
        case .concernedBlackGirlR056:   return UIImage(named: "concernedBlackGirlR056")!
        case .happyBlackGirlR056:       return UIImage(named: "happyBlackGirlR056")!
        case .sadBlackGirlR056:         return UIImage(named: "sadBlackGirlR056")!
        case .smilingBlackGirlR065:     return UIImage(named: "smilingBlackGirlR065")!
        }
    }
}


enum systemImageAsUIImage {
    static let plusLarge                = UIImage(systemName: "plus",
                                                  withConfiguration: UIImage.SymbolConfiguration(scale: .large))
    static let minusLarge               = UIImage(systemName: "minus",
                                                  withConfiguration: UIImage.SymbolConfiguration(scale: .large))
}


// MARK: - Custom Color


enum colorAsUIColor {
    static let storeBackground          = UIColor(named: "storeBackground")
    static let storeSecondaryBackground = UIColor(named: "storeSecondaryBackground")
    static let storeSecondary           = UIColor(named: "storeSecondary")
    static let storeTertiary            = UIColor(named: "storeTertiary")
    static let storePrimaryText         = UIColor(named: "storePrimaryText")
}

