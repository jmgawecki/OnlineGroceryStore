//
//  LogInVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit

final class LogInVC: UIViewController {
    // MARK: - Declaration

    var shopImageView       = ShopImageView(frame: .zero)
    
    
    
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUIElements()
        configureUIElements()
    }
    
    // MARK: - @Objectives
    
    
    @objc private func loginButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
    }
    
    
    // MARK: - UI Configuration

    // MARK: - UI Layout Configuration
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    private func configureUIElements() {
        shopImageView.image = imageAsUIImage.shoppingLadyr056
    }
    
    
    private func layoutUIElements() {
        addSubviews(shopImageView)
        
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint          (equalTo: view.topAnchor, constant: 100),
            shopImageView.heightAnchor.constraint       (equalToConstant: 250),
            shopImageView.widthAnchor.constraint        (equalTo: shopImageView.heightAnchor, multiplier: 0.56),
            shopImageView.centerXAnchor.constraint      (equalTo: view.centerXAnchor),
        ])
    }
    
    
    // MARK: - Animation
    
    
    private func animateButtonView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 0.3}) { (true) in
            switch true {
            case true:
                UIView.animate(withDuration: 0.2, animations: {viewToAnimate.alpha = 1} )
            case false:
                return
            }
        }
    }
   
}
