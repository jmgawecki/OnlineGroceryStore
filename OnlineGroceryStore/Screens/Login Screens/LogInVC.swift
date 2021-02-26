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
        configureConfirmButton()
    }
    
    // MARK: - @Objectives
    
    
    @objc private func confirmButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
        let error = valideFields()
        if error != nil {
            print(error!)
            return
        }
        signInToFirebase()
        
    }
    
    
    // MARK: - Private function
    
    
    private func configureConfirmButton() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    
    private func valideFields() -> String? {
        if email.text           == "",
           password.text        == "" {
            return "Seems like you haven't filled all fields. Please make sure that all the fields are correct"
        }
        return nil
    }
    
    
    private func signInToFirebase() {
        let emailC      = email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordC   = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: emailC!, password: passwordC!) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
                
            } else {
                self.pushToHomeScreen()
//                switch result {
//                case .none:
//                    print("none")
//                case .some(let this):
//                    print(this.user.uid)
//                    Firestore.firestore().
//
//                }
                
            }
           
            
        }
    }
    
    private func pushToHomeScreen() {
        let destVC = HomeVC()
        navigationController?.pushViewController(destVC, animated: true)
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
