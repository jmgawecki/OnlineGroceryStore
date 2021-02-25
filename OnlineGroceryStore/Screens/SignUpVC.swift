//
//  SignUpVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit

final class SignUpVC: UIViewController {
    // MARK: - Declaration
    var shopImageView       = ShopImageView(frame: .zero)
    var registerFormStackV  = UIStackView()
    
    var firstName       = registerTextField(placeholder: "First Name", capitalised: .words, isPassword: false)
    var lastName        = registerTextField(placeholder: "Last Name", capitalised: .words, isPassword: false)
    var email           = registerTextField(placeholder: "@Email", capitalised: .none, isPassword: false)
    var password        = registerTextField(placeholder: "Password", capitalised: .none, isPassword: true)
    var confirmPassword = registerTextField(placeholder: "Confirm Password", capitalised: .none, isPassword: true)
    var confirmButton   = StoreButton(fontSize: 18, label: "Sign Up!")
    
    
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUIElements()
        configureUIElements()
        configureRegisterStackView()
    }
    
    // MARK: - @Objectives
    
    
    @objc private func loginButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
    }
    
    
    // MARK: - UI Configuration
    
    
    private func configureRegisterStackView() {
        registerFormStackV.translatesAutoresizingMaskIntoConstraints = false
        registerFormStackV.axis                = .vertical
        registerFormStackV.distribution        = .fillEqually
        registerFormStackV.spacing             = 14
        registerFormStackV.backgroundColor     = UIColor(named: colorAsString.storeBackground)
        
        registerFormStackV.addArrangedSubview(firstName)
        registerFormStackV.addArrangedSubview(lastName)
        registerFormStackV.addArrangedSubview(email)
        registerFormStackV.addArrangedSubview(password)
        registerFormStackV.addArrangedSubview(confirmPassword)
        registerFormStackV.addArrangedSubview(confirmButton)
        
    }
    
    
    
    // MARK: - UI Layout Configuration
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        title = "Sign Up"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
    private func configureUIElements() {
        shopImageView.image = imageAsUIImage.shoppingLadyr071    }
    
    
    private func layoutUIElements() {
        addSubviews(shopImageView, registerFormStackV)
        
        NSLayoutConstraint.activate([
            shopImageView.bottomAnchor.constraint           (equalTo: view.bottomAnchor, constant: -50),
            shopImageView.heightAnchor.constraint           (equalToConstant: 250),
            shopImageView.widthAnchor.constraint            (equalTo: shopImageView.heightAnchor, multiplier: 0.71),
            shopImageView.centerXAnchor.constraint          (equalTo: view.centerXAnchor),
            
            registerFormStackV.bottomAnchor.constraint      (equalTo: shopImageView.topAnchor, constant: -30),
            registerFormStackV.heightAnchor.constraint      (equalToConstant: 300),
            registerFormStackV.widthAnchor.constraint       (equalToConstant: 280),
            registerFormStackV.centerXAnchor.constraint     (equalTo: view.centerXAnchor),
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
