//
//  LogInVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit
import Firebase


final class LogInVC: UIViewController {
    // MARK: - Declaration

    var shopImageView   = ShopImageView(frame: .zero)
    var loginFormStackV = UIStackView()
    
    var email           = RegisterTextField(placeholder: "@Email", capitalised: .none, isPassword: false)
    var password        = RegisterTextField(placeholder: "Password", capitalised: .none, isPassword: true)
    var confirmButton   = StoreVCButton(fontSize: 18, label: "Log In!")
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUIElements()
        configureUIElements()
        configureButtonsStackView()
        configureConfirmButton()
    }
    
    // MARK: - @Objectives
    
    
    @objc private func confirmButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        let error = valideFields()
        if error != nil {
            print(error!)
            return
        }
        logIn()
        
    }
    
    
    // MARK: - Private function
    
    
    private func configureConfirmButton() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    
    private func valideFields() -> String? {
        if email.text           == "",
           password.text        == "" {
            presentStoreAlertOnMainThread(title: .failure, message: .signUpFillAllFields, button: .willDo, image: .concernedBlackGirlR056)
            return "Error"
        }
        return nil
    }

    
    private func pushToHomeScreen(with currentUser: UserLocal) {
        let destVC = HomeVC(currentUser: currentUser)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    // MARK: - Firebase
    
    
    private func logIn() {
        FireManager.shared.signInToFirebase(email: email.text!, password: password.text!) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.pushToHomeScreen(with: user)
            case .failure(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .concernedBlackGirlR056)
            }
        }
    }
    
    
    // MARK: - UI Configuration

    
    private func configureButtonsStackView() {
        loginFormStackV.translatesAutoresizingMaskIntoConstraints = false
        loginFormStackV.axis                = .vertical
        loginFormStackV.distribution        = .fillEqually
        loginFormStackV.spacing             = 14
        loginFormStackV.backgroundColor     = StoreUIColor.creamWhite

        loginFormStackV.addArrangedSubview(email)
        loginFormStackV.addArrangedSubview(password)
        loginFormStackV.addArrangedSubview(confirmButton)
    }
    
    
    // MARK: - UI Layout Configuration
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
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
}
