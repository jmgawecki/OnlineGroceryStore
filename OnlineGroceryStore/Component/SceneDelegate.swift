//
//  SceneDelegate.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = setRootAsHomeTabBar() ?? configureEntryNavController()
        window?.makeKeyAndVisible()
        configureNavigationController()
    }

    
    private func configureEntryNavController() -> UINavigationController {
        let entryVC         = EntryVC()
        entryVC.title       = "Welcome"
        return UINavigationController(rootViewController: entryVC)
    }
    
//    private func configureHomeNavController() -> UINavigationController {
//        let entryVC         = HomeVC()
//        entryVC.title       = "Home"
//        return UINavigationController(rootViewController: entryVC)
//    }
    
    
    private func configureNavigationController() {
        UINavigationBar.appearance().tintColor = UIColor(named: colorAsString.storeTertiary)
    }
    
    
    func setRootAsHomeTabBar() -> UITabBarController? {
        var homeTabBarController: UITabBarController?
            
        if let _ = Auth.auth().currentUser { homeTabBarController = HomeTabBarController() }
        return homeTabBarController
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
      
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
 
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

