//
//  EntryVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 24/02/2021.
//

import UIKit

final class EntryVC: UIViewController {
    // MARK: - Declaration
    var loginButton         = StoreButton(fontSize: 18, label: "Log In")
    var registerButton      = StoreButton(fontSize: 18, label: "Sign Up")
    
    var shopImageView       = ShopImageView(frame: .zero)
    var buttonsStack        = UIStackView()
    
    var welcomeLabel        = StoreBoldLabel(with: "Hi there",
                                             from: .left,
                                             ofsize: 35,
                                             ofweight: .bold,
                                             alpha: 0,
                                             color: UIColor(named: colorAsString.storePrimaryText)!)
    
    var bodyLabel           = StoreBoldLabel(with: "Please log in or sign up in order to buy some awesome things!",
                                             from: .left,
                                             ofsize: 20,
                                             ofweight: .medium,
                                             alpha: 0,
                                             color: UIColor(named: colorAsString.storePrimaryText)!)
    
    
    
    // MARK: - Override, Initialiser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        configureUIElements()
        configureButtonsStackView()
        configureLoginButton()
        configureRegisterButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureVC()
        performContentAnimation(firstLabel: welcomeLabel, secondLabel: bodyLabel, anArrow: nil)
    }
    
    
    // MARK: - @Objectives
    
    
    @objc private func loginButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
        let destVC = LogInVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIView) {
        animateButtonView(sender)
        let destVC = SignUpVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    // MARK: - UI Configuration
    
    
    private func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    
    private func configureRegisterButton() {
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    
    // MARK: - UI Layout Configuration
    
    
    private func configureVC() {
        view.backgroundColor = UIColor(named: colorAsString.storeBackground)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    private func configureButtonsStackView() {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis                = .vertical
        buttonsStack.distribution        = .fillEqually
        buttonsStack.spacing             = 20
        buttonsStack.backgroundColor     = UIColor(named: colorAsString.storeBackground)

        buttonsStack.addArrangedSubview(loginButton)
        buttonsStack.addArrangedSubview(registerButton)
    }
    
    private func configureUIElements() {
        shopImageView.image = imageAsUIImage.shopBuilding
    }
    
    
    private func layoutUIElements() {
//        debugConfiguration(shopImageView,buttonsStack,welcomeLabel,bodyLabel)
        addSubviews(shopImageView, buttonsStack, welcomeLabel, bodyLabel)
        
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint          (equalTo: view.topAnchor, constant: 100),
            shopImageView.heightAnchor.constraint       (equalToConstant: 250),
            shopImageView.widthAnchor.constraint        (equalTo: shopImageView.heightAnchor, multiplier: 1.5),
            shopImageView.centerXAnchor.constraint      (equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint           (equalTo: shopImageView.bottomAnchor, constant: 10),
            welcomeLabel.widthAnchor.constraint         (equalToConstant: 250),
            welcomeLabel.heightAnchor.constraint        (equalToConstant: 45),
            welcomeLabel.leadingAnchor.constraint       (equalTo: shopImageView.leadingAnchor, constant: 15),
            
            bodyLabel.topAnchor.constraint              (equalTo: welcomeLabel.bottomAnchor),
            bodyLabel.widthAnchor.constraint            (equalToConstant: 310),
            bodyLabel.heightAnchor.constraint           (equalToConstant: 65),
            bodyLabel.leadingAnchor.constraint          (equalTo: shopImageView.leadingAnchor, constant: 15),
            
            buttonsStack.bottomAnchor.constraint        (equalTo: view.bottomAnchor, constant: -80),
            buttonsStack.heightAnchor.constraint        (equalToConstant: 110),
            buttonsStack.widthAnchor.constraint         (equalToConstant: 280),
            buttonsStack.centerXAnchor.constraint       (equalTo: view.centerXAnchor),
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
    
    private func performContentAnimation(firstLabel: UIView, secondLabel: UIView, anArrow: UIImageView?) {
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
