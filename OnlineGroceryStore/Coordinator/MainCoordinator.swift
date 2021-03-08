//
//  MainCoordinator.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 07/03/2021.
//

import UIKit



class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    // MARK: - Coordinator: Run the App
    
    func startFromEntryVC() {
        var startingVC: UIViewController & Coordinating = EntryVC()
        startingVC.coordinator = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setViewControllers([startingVC], animated: false)
    }
    
    
    func startFromHomeVC() {
        var startingVC: UITabBarController & Coordinating = HomeTabBarController()
        startingVC.coordinator = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setViewControllers([startingVC], animated: false)
    }
    
    
    func pushVCWithUser(with userParameter: UserLocal, viewController: UIViewController & Coordinating, isNavigationHidden: Bool) {
        var pushedVC: UIViewController & Coordinating = viewController
        pushedVC.coordinator = self
        navigationController?.setNavigationBarHidden(isNavigationHidden, animated: true)
        navigationController?.pushViewController(pushedVC, animated: true)
    }
}
