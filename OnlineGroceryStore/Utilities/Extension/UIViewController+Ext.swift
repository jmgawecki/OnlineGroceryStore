//
//  UIViewController+Ext.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

extension UIViewController {
    
    func addSubviews(_ views: UIView...) { for view in views { self.view.addSubview(view) } }
    
    func debugConfiguration(_ views: UIView...) {
        for view in views {
            view.layer.borderWidth = 1 }
    }
    
    
    func presentStoreAlertOnMainThread(title: AlertTitle, message: AlertMessages, button: AlertButtonTitle, image: AlertImage) {
        DispatchQueue.main.async {
            let alertVC = StoreAlertVC(title: title, message: message, buttonTitle: button, image: image)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func presentStoreAlertOnMainThreadBottomWindow(title: AlertTitle, message: AlertMessages, button: AlertButtonTitle, image: AlertImage) {
        DispatchQueue.main.async {
            let alertVC = StoreAlertVC(title: title, message: message, buttonTitle: button, image: image)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
}
