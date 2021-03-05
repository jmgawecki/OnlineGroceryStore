//
//  HomeTabBarController.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class HomeTabBarController: UITabBarController {
    // MARK: - Declaration
    
    
    var currentUser: UserLocal!

    
    // MARK: - Override and Initialise
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        getCurrentUser()
    }
    
    
    // MARK: - Tabbar Configuration
    
    
    private func configureTabBarController() {
        UITabBar.appearance().tintColor         = UIColor(named: colorAsString.storePrimaryText)
        UINavigationBar.appearance().tintColor  = UIColor(named: colorAsString.storePrimaryText)
        viewControllers                         = [createHomeNavigationCotroller(),
                                                   createFavoritesNavigationController(),
                                                   createSearchNavigationController(),
                                                   createOrdersNavigationController(),
                                                   createBasketNavigationController()]
    }
    
    
    // MARK: - VC Configuration
    
    
    private func createHomeNavigationCotroller() -> UINavigationController {
        let homeVC = HomeVC(currentUser: currentUser)
        homeVC.title                          = "Home"
        homeVC.tabBarItem                     = UITabBarItem(title: "Home", image: UIImage(systemName: systemImageAsString.home), tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createFavoritesNavigationController() -> UINavigationController {
        let homeVC = FavoritesVC(currentUser: currentUser)
        homeVC.title                          = "Favorites"
        homeVC.tabBarItem                     = UITabBarItem(title: "Favorites", image: UIImage(systemName: systemImageAsString.favorites), tag: 1)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createSearchNavigationController() -> UINavigationController {
        let homeVC = SearchVC(currentUser: currentUser)
        homeVC.title                          = "Search"
        homeVC.tabBarItem                     = UITabBarItem(title: "Search", image: UIImage(systemName: systemImageAsString.search), tag: 2)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createOrdersNavigationController() -> UINavigationController {
        let homeVC = OrdersVC(currentUser: currentUser)
        homeVC.title                          = "Orders"
        homeVC.tabBarItem                     = UITabBarItem(title: "Orders", image: UIImage(systemName: systemImageAsString.orders), tag: 3)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createBasketNavigationController() -> UINavigationController {
        let homeVC = BasketVC(currentUser: currentUser)
        homeVC.title                          = "Basket"
        homeVC.tabBarItem                     = UITabBarItem(title: "Basket", image: UIImage(systemName: systemImageAsString.basket), tag: 4)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    // MARK: - Firebase
    

    private func getCurrentUser() {
        FireManager.shared.getCurrentUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser = user
                self.configureTabBarController()
            case .failure(let error):
                print(error)
            }
        }
    }
}
