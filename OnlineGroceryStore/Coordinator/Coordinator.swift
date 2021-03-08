//
//  Coordinator.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 07/03/2021.
//

import UIKit


protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    func startFromEntryVC()
    
    func startFromHomeVC()
    
    func pushVCWithUser(with userParameter: UserLocal, viewController: UIViewController & Coordinating, isNavigationHidden: Bool)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
