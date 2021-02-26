//
//  UIView+Ext.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

extension UIView {
    func debugConfiguration(_ views: UIView...) {
        for view in views {
            view.layer.borderWidth = 1 }
    }
    
    func addSubviews(_ views: UIView...) { for view in views { self.addSubview(view) } }
}
