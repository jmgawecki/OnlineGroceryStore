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
//        let NavC = UINavigationController()
//
//        let coordinator = MainCoordinator()
//        coordinator.navigationController = NavC
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = isUserSessionOn() ? setRootAsHomeTabBar() : configureEntryNavController()
        window.makeKeyAndVisible()
        self.window = window
        
//        if isUserSessionOn() {
//            coordinator.startFromHomeVC()
//        } else {
//            coordinator.startFromEntryVC()
//        }
        configureNavigationController()
    }

    
    private func configureEntryNavController() -> UINavigationController {
        let entryVC         = EntryVC()
        entryVC.title       = "Welcome"
        return UINavigationController(rootViewController: entryVC)
    }
    
    
    private func configureNavigationController() {
        UINavigationBar.appearance().tintColor = StoreUIColor.darkGreen
    }
    
    func isUserSessionOn() -> Bool {
        if let _ = Auth.auth().currentUser { return true } else {
            return false
        }
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

