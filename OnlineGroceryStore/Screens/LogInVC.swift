//
//  LogInVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit

final class LogInVC: UIViewController {
    // MARK: - Declaration

    var shopImageView   = ShopImageView(frame: .zero)
    var loginFormStackV = UIStackView()
    
    var email           = registerTextField(placeholder: "@Email", capitalised: .none, isPassword: false)
    var password        = registerTextField(placeholder: "Password", capitalised: .none, isPassword: true)
    var confirmButton   = StoreButton(fontSize: 18, label: "Log In!")
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUIElements()
        configureUIElements()
        configureButtonsStackView()
    }
    
    // MARK: - @Objectives
    
    
    @objc private func loginButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
    }
    
    
    // MARK: - UI Configuration

    
    private func configureButtonsStackView() {
        loginFormStackV.translatesAutoresizingMaskIntoConstraints = false
        loginFormStackV.axis                = .vertical
        loginFormStackV.distribution        = .fillEqually
        loginFormStackV.spacing             = 14
        loginFormStackV.backgroundColor     = UIColor(named: colorAsString.storeBackground)

        loginFormStackV.addArrangedSubview(email)
        loginFormStackV.addArrangedSubview(password)
        loginFormStackV.addArrangedSubview(confirmButton)
    }
    
    
    // MARK: - UI Layout Configuration
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        title                = "Log In"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    private func configureUIElements() {
        shopImageView.image = imageAsUIImage.shoppingLadyr056
    }
    
    
    private func layoutUIElements() {
        addSubviews(shopImageView, loginFormStackV)
        
        NSLayoutConstraint.activate([
            shopImageView.bottomAnchor.constraint       (equalTo: view.bottomAnchor, constant: -50),
            shopImageView.heightAnchor.constraint       (equalToConstant: 250),
            shopImageView.widthAnchor.constraint        (equalTo: shopImageView.heightAnchor, multiplier: 0.56),
            shopImageView.centerXAnchor.constraint      (equalTo: view.centerXAnchor),
            
            loginFormStackV.bottomAnchor.constraint     (equalTo: shopImageView.topAnchor, constant: -30),
            loginFormStackV.heightAnchor.constraint     (equalToConstant: 150),
            loginFormStackV.widthAnchor.constraint      (equalToConstant: 280),
            loginFormStackV.centerXAnchor.constraint    (equalTo: view.centerXAnchor),
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
