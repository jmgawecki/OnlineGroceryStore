//
//  HomeTabBarController.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 26/02/2021.
//

import UIKit

final class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        UITabBar.appearance().tintColor         = UIColor(named: colorAsString.storePrimaryText)
        UINavigationBar.appearance().tintColor  = UIColor(named: colorAsString.storePrimaryText)
        viewControllers                         = [createHomeNavigationCotroller(),
                                                   createFavoritesNavigationController(),
                                                   createSearchNavigationController(),
                                                   createOrdersNavigationController(),
                                                   createBasketNavigationController()]
    }
    
    
    private func createHomeNavigationCotroller() -> UINavigationController {
        let homeVC = HomeVC()
        homeVC.title                          = "Home"
        homeVC.tabBarItem                     = UITabBarItem(title: "Home", image: UIImage(systemName: systemImageAsString.home), tag: 0)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createFavoritesNavigationController() -> UINavigationController {
        let homeVC = FavoritesVC()
        homeVC.title                          = "Favorites"
        homeVC.tabBarItem                     = UITabBarItem(title: "Favorites", image: UIImage(systemName: systemImageAsString.favorites), tag: 1)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createSearchNavigationController() -> UINavigationController {
        let homeVC = SearchVC()
        homeVC.title                          = "Search"
        homeVC.tabBarItem                     = UITabBarItem(title: "Search", image: UIImage(systemName: systemImageAsString.search), tag: 2)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createOrdersNavigationController() -> UINavigationController {
        let homeVC = OrdersVC()
        homeVC.title                          = "Orders"
        homeVC.tabBarItem                     = UITabBarItem(title: "Orders", image: UIImage(systemName: systemImageAsString.orders), tag: 3)
        return UINavigationController(rootViewController: homeVC)
    }
    
    
    private func createBasketNavigationController() -> UINavigationController {
        let homeVC = BasketVC()
        homeVC.title                          = "Basket"
        homeVC.tabBarItem                     = UITabBarItem(title: "Basket", image: UIImage(systemName: systemImageAsString.basket), tag: 4)
        return UINavigationController(rootViewController: homeVC)
    }

}
