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
}
