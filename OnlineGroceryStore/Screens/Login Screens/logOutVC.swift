//
//  logOutVC.swift
//  OnlineGroceryStore
//
//  Created by Jakub Gawecki on 25/02/2021.
//

import UIKit

final class logOutVC: UIViewController {

    // MARK: - Declaration
    var loginButton         = StoreVCButton(fontSize: 18, label: "Log In")
    var registerButton      = StoreVCButton(fontSize: 18, label: "Sign Up")
    
    var shopImageView       = ShopImageView(frame: .zero)
    var buttonsStack        = UIStackView()
    
    var byeLabel            = StoreBoldLabel(with: "We hope to see You around very soon!",
                                             from: .left,
                                             ofsize: 35,
                                             ofweight: .bold,
                                             alpha: 1,
                                             color: StoreUIColor.grapefruit ?? .orange)
    
    
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
    }
    
    
    // MARK: - @Objectives
    
    
    @objc private func loginButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
        let destVC = LogInVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    @objc private func registerButtonTapped(_ sender: UIView) {
        StoreAnimation.animateClickedView(sender, animationDuration: 0.2, middleAlpha: 0.3, endAlpha: 1)
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
        view.backgroundColor = StoreUIColor.creamWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    private func configureButtonsStackView() {
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis                = .vertical
        buttonsStack.distribution        = .fillEqually
        buttonsStack.spacing             = 20
        buttonsStack.backgroundColor     = StoreUIColor.creamWhite

        buttonsStack.addArrangedSubview(loginButton)
        buttonsStack.addArrangedSubview(registerButton)
    }
    
    private func configureUIElements() {
        shopImageView.image = storeUIImage.wavingPeopleR088
        
        loginButton.backgroundColor = StoreUIColor.grapefruit
        registerButton.backgroundColor = StoreUIColor.grapefruit
    }
    
    
    private func layoutUIElements() {
        addSubviews(shopImageView, buttonsStack, byeLabel)
        
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint          (equalTo: view.topAnchor, constant: 100),
            shopImageView.heightAnchor.constraint       (equalToConstant: 250),
            shopImageView.widthAnchor.constraint        (equalTo: shopImageView.heightAnchor, multiplier: 0.88),
            shopImageView.centerXAnchor.constraint      (equalTo: view.centerXAnchor),
            
            byeLabel.topAnchor.constraint               (equalTo: shopImageView.bottomAnchor, constant: 10),
            byeLabel.widthAnchor.constraint             (equalToConstant: 320),
            byeLabel.heightAnchor.constraint            (equalToConstant: 100),
            byeLabel.leadingAnchor.constraint           (equalTo: view.leadingAnchor, constant: 15),
            
            buttonsStack.bottomAnchor.constraint        (equalTo: view.bottomAnchor, constant: -80),
            buttonsStack.heightAnchor.constraint        (equalToConstant: 110),
            buttonsStack.widthAnchor.constraint         (equalToConstant: 280),
            buttonsStack.centerXAnchor.constraint       (equalTo: view.centerXAnchor),
        ])
    }
}
