//
//  StoreAnimation.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 07/03/2021.
//

import UIKit

struct StoreAnimation {
    
    
    /// Animates view that its alpha is 0 to 1 in 1 second with the delay
    /// - Parameter viewToAnimate: UIView
    static func animateViewToAppear(_ viewToAnimate: UIView, animationDuration: TimeInterval, animationDelay: TimeInterval) {
        UIView.animate(withDuration: animationDuration, delay: animationDelay) {
            viewToAnimate.alpha = 1
        }
    }
    
    
    /// Animate the view's alpha when animated view is pressed
    /// - Parameter viewToAnimate: UIView
    static func animateClickedView(_ viewToAnimate: UIView, animationDuration: TimeInterval, middleAlpha: CGFloat, endAlpha: CGFloat) {
        UIView.animate(withDuration: animationDuration, animations: {viewToAnimate.alpha = middleAlpha}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: animationDuration, animations: {viewToAnimate.alpha = endAlpha} )
            case false:
                return
            }
        }
    }
    
    
    static func animateEntryVC(firstLabel: UIView, secondLabel: UIView, anArrow: UIImageView?) {
        UIView.animate(withDuration: 1) {
            firstLabel.alpha = 1
        } completion: { (_) in
            UIView.animate(withDuration: 0.75) {
                secondLabel.alpha = 1
            } completion: { (_) in
                UIView.animate(withDuration: 0.5) {
                    if anArrow != nil{
                        anArrow!.alpha = 1
                    }
                    
                }
            }
            
        }
        
    }
    
}


