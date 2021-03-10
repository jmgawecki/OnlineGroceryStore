//
//  SignUpVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit
import FirebaseAuth
import Firebase

final class SignUpVC: UIViewController {
    // MARK: - Declaration
    var shopImageView       = ShopImageView(frame: .zero)
    var registerFormStackV  = UIStackView()
    
    var firstName           = RegisterTextField(placeholder: "First Name", capitalised: .words, isPassword: false)
    var lastName            = RegisterTextField(placeholder: "Last Name", capitalised: .words, isPassword: false)
    var email               = RegisterTextField(placeholder: "@Email", capitalised: .none, isPassword: false)
    var password            = RegisterTextField(placeholder: "Password", capitalised: .none, isPassword: true)
    var confirmPassword     = RegisterTextField(placeholder: "Confirm Password", capitalised: .none, isPassword: true)
    var confirmButton       = StoreVCButton(fontSize: 18, label: "Sign Up!")
    
    var currentUser: UserLocal?
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUIElements()
        configureUIElements()
        configureRegisterStackView()
        configureConfirmButton()
    }
    
    // MARK: - @Objectives
    
    
    @objc private func confirmButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        // validate
        let error = valideFields()
        if error != nil {
            print(error!)
            return
        }
        createUser()
    }
    
    
    // MARK: - Private Function
    
    
    private func configureConfirmButton() { confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside) }
    
    
    private func pushToHomeScreen(with currentUser: UserLocal) {
        let destVC = HomeVC(currentUser: currentUser)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    private func valideFields() -> String? {
        if firstName.text       == "",
           lastName.text        == "",
           email.text           == "",
           password.text        == "",
           confirmPassword.text == "" {
            presentStoreAlertOnMainThread(title: .failure, message: .signUpFillAllFields, button: .willDo, image: .concernedBlackGirlR056)
            return "Error"
        }
        if password.text != confirmPassword.text {
            presentStoreAlertOnMainThread(title: .failure, message: .passwordsArentMatching, button: .willDo, image: .concernedBlackGirlR056)
            return "Error"
        } else if HelpFunctions.isPasswordValid(for: password.text!) == false {
            presentStoreAlertOnMainThread(title: .failure, message: .passwordBadFormat, button: .willDo, image: .sadBlackGirlR056)
            return "Error"
        }
        return nil
    }
    
    
    // MARK: - Firebase
    
    
    func createUser() {
        FireManager.shared.createUserInFirebase(firstName: firstName.text!, lastName: lastName.text!, email: email.text!, password: password.text!) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                self.currentUser = currentUser
                self.pushToHomeScreen(with: self.currentUser!)
            case .failure(_):
                self.presentStoreAlertOnMainThread(title: .failure, message: .checkInternet, button: .willDo, image: .concernedBlackGirlR056)
            }
        }
    }
    
    
    // MARK: - UI Configuration
    
    
    private func configureVC() {
        view.backgroundColor = StoreUIColor.creamWhite
        title = "Sign Up"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    private func configureUIElements() { shopImageView.image = storeUIImage.shoppingLadyr071 }
    
    
    private func configureRegisterStackView() {
        registerFormStackV.translatesAutoresizingMaskIntoConstraints = false
        registerFormStackV.axis                = .vertical
        registerFormStackV.distribution        = .fillEqually
        registerFormStackV.spacing             = 14
        registerFormStackV.backgroundColor     = StoreUIColor.creamWhite
        
        registerFormStackV.addArrangedSubview(firstName)
        registerFormStackV.addArrangedSubview(lastName)
        registerFormStackV.addArrangedSubview(email)
        registerFormStackV.addArrangedSubview(password)
        registerFormStackV.addArrangedSubview(confirmPassword)
        registerFormStackV.addArrangedSubview(confirmButton)
        
    }
    
    
    // MARK: - UI Layout
    
    
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
}
